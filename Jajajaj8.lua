Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UIS = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
HS = game:GetService("HttpService")
if _G.DragonRunning then return end
_G.DragonRunning = true

player = Players.LocalPlayer

-- Local copy guard: protects only duplicate Dragon interface instances.
-- It deliberately leaves the player's clipboard, console and session untouched.
DragonCopyGuard=DragonCopyGuard or {protected=nil,connections={}}
function DragonProtectGui(gui)
    local guard=DragonCopyGuard
    guard.protected=gui
    for _,connection in ipairs(guard.connections) do pcall(function() connection:Disconnect() end) end
    table.clear(guard.connections)
    local function removeDuplicate(instance)
        if instance~=gui and instance:IsA("ScreenGui") and instance.Name=="Dragon" then
            task.defer(function()
                if instance and instance.Parent and instance~=guard.protected then pcall(function() instance:Destroy() end) end
            end)
        end
    end
    for _,parent in ipairs({game:GetService("CoreGui"),player:FindFirstChildOfClass("PlayerGui")}) do
        if parent then
            for _,item in ipairs(parent:GetDescendants()) do removeDuplicate(item) end
            table.insert(guard.connections,parent.DescendantAdded:Connect(removeDuplicate))
        end
    end
end

-- Duplicate protection is handled by DragonProtectGui once the Dragon GUI exists.
-- Do not monitor CoreGui globally or inspect the clipboard: executors commonly add
-- temporary objects during auto-execution, which would otherwise cause false positives.
function DragonStartAntiCopyLock()
    if DragonCopyGuard.fullLockStarted then return end
    DragonCopyGuard.fullLockStarted=true
end
DragonStartAntiCopyLock()

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD (for intro sound setting)
-- ------------------------------------------------------------
Dragon_CONFIG_FILE="Dragon_Config.json"
Dragon_BUTTONS_FILE="Dragon_MobileButtons.json"
-- Keep the steal-bar scale in a tiny dedicated file as well.  Some mobile
-- executors interrupt a larger config write when the interface is rebuilt.
Dragon_STEALBAR_SIZE_FILE="Dragon_StealBarSize.json"
introSkipEnabled=false
introVersion=1
introSongIndex=1
introBackgroundIndex=1
snowUiThemeName="BIANCO"
-- Saved once on the first launch.  This is deliberately loaded before the
-- intro so the selected visual profile is already active when Dragon starts.
DragonPerformanceProfile=nil
Dragon_INTRO_BACKGROUNDS={
    "rbxassetid://85619631212713",
    "rbxassetid://118253749026483",
    "rbxassetid://107100155657036",
}
Dragon_INTRO_SONGS={
    {url="https://files.catbox.moe/vbyghu.mp3",file="dragon_intro_song_1.mp3"},
    {url="https://files.catbox.moe/5g2wg1.mp3",file="dragon_intro_song_2.mp3"},
    {url="https://files.catbox.moe/r29x0i.mp3",file="dragon_intro_song_3.mp3"},
    {url="https://files.catbox.moe/n53amf.mp3",file="dragon_intro_song_4.mp3"},
    {url="https://files.catbox.moe/o4di3j.mp3",file="dragon_intro_song_5.mp3"},
    {url="https://files.catbox.moe/um4hgp.mp3",file="dragon_intro_song_6.mp3"},
    {url="https://files.catbox.moe/fiiu4a.mp3",file="dragon_intro_song_7.mp3"},
    {url="https://files.catbox.moe/mdjmee.mp3",file="dragon_intro_song_8.mp3"},
    {url="https://files.catbox.moe/2eysnf.mp3",file="dragon_intro_song_9.mp3"},
    {url="https://files.catbox.moe/d4uky5.mp3",file="dragon_intro_song_10.mp3"},
    {url="https://files.catbox.moe/8v5xra.mp3",file="dragon_intro_song_11.mp3"},
    {url="https://files.catbox.moe/aneanv.mp3",file="dragon_intro_song_12.mp3"},
    {url="https://files.catbox.moe/pm6lne.mp3",file="dragon_intro_song_13.mp3"},
    {url="https://files.catbox.moe/y4q5y3.mp3",file="dragon_intro_song_14.mp3"},
    {url="https://files.catbox.moe/pcdvty.mp3",file="dragon_intro_song_15.mp3"},
    {url="https://files.catbox.moe/vsajzl.mp3",file="dragon_intro_song_16.mp3"},
    {url="https://files.catbox.moe/15b4d5.mp3",file="dragon_intro_song_17.mp3"},
    {url="https://files.catbox.moe/o31n99.mp3",file="dragon_intro_song_18.mp3"},
    {url="https://files.catbox.moe/yaijit.mp3",file="dragon_intro_song_19.mp3"},
    {url="https://files.catbox.moe/wcul5c.mp3",file="dragon_intro_song_20.mp3"},
    {url="https://files.catbox.moe/mk3bsn.mp3",file="dragon_intro_song_21.mp3"},
    {url="https://files.catbox.moe/ugqfwd.mp3",file="dragon_intro_song_22.mp3"},
    {url="https://files.catbox.moe/fx4yfi.mp3",file="dragon_intro_song_23.mp3"},
}
Dragon_INTRO_PREVIEW_ID=0
Dragon_INTRO_BACKGROUND_PREVIEW_ID=0
function playDragonIntroBackgroundPreview(index)
    Dragon_INTRO_BACKGROUND_PREVIEW_ID=Dragon_INTRO_BACKGROUND_PREVIEW_ID+1
    local previewId=Dragon_INTRO_BACKGROUND_PREVIEW_ID
    local function removeOld(parent)
        local old=parent and parent:FindFirstChild("Dragon_IntroBackgroundPreview")
        if old then old:Destroy() end
    end
    pcall(function() removeOld(game:GetService("CoreGui")) end)
    removeOld(player and player:FindFirstChild("PlayerGui"))
    local preview=Instance.new("ScreenGui")
    preview.Name="Dragon_IntroBackgroundPreview"; preview.IgnoreGuiInset=true; preview.ResetOnSpawn=false; preview.DisplayOrder=100001; preview.ZIndexBehavior=Enum.ZIndexBehavior.Global
    if not pcall(function() preview.Parent=game:GetService("CoreGui") end) then preview.Parent=player:WaitForChild("PlayerGui") end
    local bg=Instance.new("ImageLabel",preview); bg.AnchorPoint=Vector2.new(.5,.5); bg.Position=UDim2.new(.5,0,.5,0); bg.Size=UDim2.new(0,14,0,14); bg.BackgroundTransparency=1; bg.ScaleType=Enum.ScaleType.Fit; bg.Image=Dragon_INTRO_BACKGROUNDS[math.clamp(tonumber(index) or 1,1,#Dragon_INTRO_BACKGROUNDS)]; bg.ImageTransparency=.12; bg.ZIndex=1
    local front=Instance.new("ImageLabel",preview); front.AnchorPoint=Vector2.new(.5,.5); front.Position=UDim2.new(.5,0,.5,70); front.Size=UDim2.new(0,14,0,14); front.BackgroundTransparency=1; front.ScaleType=Enum.ScaleType.Fit; front.Image="rbxassetid://77790957712601"; front.ZIndex=2
    TweenService:Create(bg,TweenInfo.new(.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,610,0,610)}):Play()
    TweenService:Create(front,TweenInfo.new(.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,500,0,500)}):Play()
    task.delay(2,function()
        if previewId==Dragon_INTRO_BACKGROUND_PREVIEW_ID and preview and preview.Parent then preview:Destroy() end
    end)
end
function playDragonIntroSongPreview(index,duration)
    Dragon_INTRO_PREVIEW_ID=Dragon_INTRO_PREVIEW_ID+1
    local previewId=Dragon_INTRO_PREVIEW_ID
    local soundService=game:GetService("SoundService")
    local old=soundService:FindFirstChild("Dragon_IntroPreview")
    if old then pcall(function() old:Stop(); old:Destroy() end) end
    local song=Dragon_INTRO_SONGS[math.clamp(tonumber(index) or 1,1,#Dragon_INTRO_SONGS)]
    task.spawn(function()
        local function assetFor(fileName)
            for _,fn in ipairs({getcustomasset,getsynasset,getasset}) do
                if typeof(fn)=="function" then local ok,asset=pcall(function() return fn(fileName) end); if ok and type(asset)=="string" and asset~="" then return asset end end
            end
            return ""
        end
        local asset=(isfile and isfile(song.file)) and assetFor(song.file) or ""
        if asset=="" then
            local ok,raw=pcall(function() return game:HttpGet(song.url) end)
            if (not ok or not raw or #raw<100) then return end
            if not pcall(function() writefile(song.file,raw) end) then return end
            asset=assetFor(song.file)
        end
        if previewId~=Dragon_INTRO_PREVIEW_ID or asset=="" then return end
        local sound=Instance.new("Sound"); sound.Name="Dragon_IntroPreview"; sound.SoundId=asset; sound.Volume=1; sound.Parent=soundService
        pcall(function() sound:Play() end)
        task.delay(duration or 3,function()
            if sound and sound.Parent then pcall(function() sound:Stop(); sound:Destroy() end) end
        end)
    end)
end
if isfile and isfile(Dragon_CONFIG_FILE) then
    local ok2, d2 = pcall(function() return HS:JSONDecode(readfile(Dragon_CONFIG_FILE)) end)
    if ok2 and type(d2)=="table" then
        if type(d2.backgroundEnabled)=="boolean" then backgroundEnabled=d2.backgroundEnabled end
        if type(d2.backgroundIndex)=="number" then backgroundIndex=d2.backgroundIndex end
        -- The interface currently has one fixed white theme.
        snowUiThemeName="BIANCO"
        if type(d2.introSkipEnabled)=="boolean" then introSkipEnabled=d2.introSkipEnabled end
        introVersion=1
        if type(d2.introSongIndex)=="number" then introSongIndex=math.clamp(math.floor(d2.introSongIndex),1,#Dragon_INTRO_SONGS) end
        if type(d2.introBackgroundIndex)=="number" then introBackgroundIndex=math.clamp(math.floor(d2.introBackgroundIndex),1,#Dragon_INTRO_BACKGROUNDS) end
        if d2.performanceProfile=="OPTIMIZE" or d2.performanceProfile=="QUALITY" then
            DragonPerformanceProfile=d2.performanceProfile
        end
    end
end

-- This small early writer is used only by the first-launch picker, before
-- saveConfig exists.  It preserves every existing option in the JSON file.
function DragonSavePerformanceProfileEarly(profile)
    DragonPerformanceProfile=profile
    if not (writefile and HS) then return end
    pcall(function()
        local cfg={}
        if isfile and isfile(Dragon_CONFIG_FILE) then
            local loaded=HS:JSONDecode(readfile(Dragon_CONFIG_FILE))
            if type(loaded)=="table" then cfg=loaded end
        end
        -- The profile is intentionally independent from the user's Anti Lag
        -- and Script Optimizer switches.
        cfg.performanceProfile=profile
        writefile(Dragon_CONFIG_FILE,HS:JSONEncode(cfg))
    end)
end

repeat task.wait() until game:IsLoaded()

-- HUD elements wait for the cinematic intro instead of appearing over it.
Dragon_INTRO_DONE=false
Dragon_INTRO_WAITERS={}
function dragonAfterIntro(callback)
    if Dragon_INTRO_DONE then task.spawn(callback) else table.insert(Dragon_INTRO_WAITERS,callback) end
end
function dragonFinishIntro()
    if Dragon_INTRO_DONE then return end
    Dragon_INTRO_DONE=true
    local waiters=Dragon_INTRO_WAITERS; Dragon_INTRO_WAITERS={}
    for _,callback in ipairs(waiters) do task.spawn(function() pcall(callback) end) end
end

-- ------------------------------------------------------------
-- INTRO — Clean cinematic logo (Fiction Duels style animation)
-- Image keeps original shape | Smooth scale + soft float
-- 15s max | tap to skip
-- Updated: Discord invite in circle intro
-- ------------------------------------------------------------
task.spawn(function()
    local Players      = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    -- First-run profile picker: this blocks the cinematic intro only until the
    -- player chooses, then the choice is persisted for all following launches.
    DragonOpenPerformanceProfilePicker=function(forceOpen)
        if not forceOpen and (DragonPerformanceProfile=="OPTIMIZE" or DragonPerformanceProfile=="QUALITY") then return end
        pcall(function()
            local old=game:GetService("CoreGui"):FindFirstChild("Dragon_PerformanceProfile")
            if old then old:Destroy() end
        end)
        local picker=Instance.new("ScreenGui")
        picker.Name="Dragon_PerformanceProfile"; picker.IgnoreGuiInset=true; picker.ResetOnSpawn=false; picker.DisplayOrder=100002; picker.ZIndexBehavior=Enum.ZIndexBehavior.Global
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(picker) end end)
        if not pcall(function() picker.Parent=game:GetService("CoreGui") end) then picker.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
        local shade=Instance.new("Frame",picker); shade.Size=UDim2.fromScale(1,1); shade.BackgroundColor3=Color3.fromRGB(0,0,0); shade.BackgroundTransparency=1; shade.BorderSizePixel=0
        local panel=Instance.new("Frame",shade); panel.AnchorPoint=Vector2.new(.5,.5); panel.Position=UDim2.fromScale(.5,.5); panel.Size=UDim2.new(0,500,0,330); panel.BackgroundColor3=Color3.fromRGB(0,0,0); panel.BackgroundTransparency=1; panel.BorderSizePixel=0
        local panelCorner=Instance.new("UICorner",panel); panelCorner.CornerRadius=UDim.new(0,18)
        local panelStroke=Instance.new("UIStroke",panel); panelStroke.Color=Color3.fromRGB(255,255,255); panelStroke.Transparency=1; panelStroke.Thickness=1.3
        local watermark=Instance.new("ImageLabel",panel); watermark.Visible=false
        local topLine=Instance.new("Frame",panel); topLine.Visible=false
        local camera=workspace.CurrentCamera
        local scale=Instance.new("UIScale",panel); scale.Scale=math.clamp(((camera and camera.ViewportSize.X) or 640)/640,.72,1)
        local logo=Instance.new("ImageLabel",panel); logo.AnchorPoint=Vector2.new(.5,0); logo.Position=UDim2.new(.5,0,0,8); logo.Size=UDim2.new(0,96,0,96); logo.BackgroundTransparency=1; logo.Image="rbxassetid://91781095721218"; logo.ScaleType=Enum.ScaleType.Fit
        local title=Instance.new("TextLabel",panel); title.Position=UDim2.new(0,22,0,106); title.Size=UDim2.new(1,-44,0,32); title.BackgroundTransparency=1; title.Text="DRAGON PERFORMANCE CORE"; title.TextColor3=Color3.fromRGB(255,255,255); title.TextSize=21; title.Font=Enum.Font.GothamBlack
        local subtitle=Instance.new("TextLabel",panel); subtitle.Visible=false
        local selected=false
        local function makeChoice(profile,titleText,description,x,color)
            local button=Instance.new("TextButton",panel); button.Position=UDim2.new(0,x,0,152); button.Size=UDim2.new(0,215,0,118); button.BackgroundColor3=color; button.BackgroundTransparency=.32; button.BorderSizePixel=0; button.Text=""; button.AutoButtonColor=false
            local corner=Instance.new("UICorner",button); corner.CornerRadius=UDim.new(0,13)
            local stroke=Instance.new("UIStroke",button); stroke.Color=color; stroke.Transparency=1; stroke.Thickness=1.2
            local accent=Instance.new("Frame",button); accent.Visible=false
            local name=Instance.new("TextLabel",button); name.Size=UDim2.fromScale(1,1); name.BackgroundTransparency=1; name.Text=titleText; name.TextColor3=Color3.fromRGB(255,255,255); name.TextSize=21; name.Font=Enum.Font.GothamBlack; name.TextXAlignment=Enum.TextXAlignment.Center; name.TextYAlignment=Enum.TextYAlignment.Center
            local desc=Instance.new("TextLabel",button); desc.Visible=false
            local selectText=Instance.new("TextLabel",button); selectText.Visible=false
            button.MouseEnter:Connect(function() if not selected then TweenService:Create(button,TweenInfo.new(.15),{BackgroundTransparency=.18}):Play() end end)
            button.MouseLeave:Connect(function() if not selected then TweenService:Create(button,TweenInfo.new(.15),{BackgroundTransparency=.32}):Play() end end)
            button.MouseButton1Click:Connect(function()
                if selected then return end
                selected=true
                DragonSavePerformanceProfileEarly(profile)
                TweenService:Create(panel,TweenInfo.new(.22),{BackgroundTransparency=1}):Play(); TweenService:Create(shade,TweenInfo.new(.22),{BackgroundTransparency=1}):Play()
                task.delay(.24,function() if picker then picker:Destroy() end end)
            end)
        end
        makeChoice("OPTIMIZE","OPTIMIZE","Recommended for slower devices. Uses Dragon's lightweight visual refresh profile for the smoothest possible experience.",30,Color3.fromRGB(71,205,154))
        makeChoice("QUALITY","QUALITY","Recommended for faster devices. Keeps the current full-quality visuals and behavior.",255,Color3.fromRGB(232,72,82))
        local footer=Instance.new("TextLabel",panel); footer.Visible=false
        repeat task.wait() until selected
    end
    DragonOpenPerformanceProfilePicker()

    -- remove leftover intros that can block the whole screen
    pcall(function()
        for _,name in ipairs({"Dragon_Intro"}) do
            local cg = game:GetService("CoreGui")
            local old = cg:FindFirstChild(name)
            if old then old:Destroy() end
            local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local o = pg:FindFirstChild(name)
                if o then o:Destroy() end
            end
        end
    end)

    if introSkipEnabled then
        pcall(function() local old=game:GetService("SoundService"):FindFirstChild("Dragon_IntroSong"); if old then old:Stop(); old:Destroy() end end)
        dragonFinishIntro(); return
    end

    -- Three-piece dragon intro: the body stays centered while independent wings
    -- open, close, and beat.  No labels or background are shown.
    if true then
        local sg=Instance.new("ScreenGui")
        sg.Name="Dragon_Intro"; sg.IgnoreGuiInset=true; sg.ResetOnSpawn=false; sg.DisplayOrder=100000; sg.ZIndexBehavior=Enum.ZIndexBehavior.Global
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
        if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then sg.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
        local stage=Instance.new("Frame",sg); stage.Name="DragonWingStage"; stage.AnchorPoint=Vector2.new(.5,.5); stage.Position=UDim2.fromScale(.5,.5); stage.Size=UDim2.fromOffset(760,500); stage.BackgroundTransparency=1
        local scale=Instance.new("UIScale",stage)
        local function fitStage()
            local view=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800,600)
            scale.Scale=math.clamp(math.min((view.X-20)/760,(view.Y-20)/500),.38,1)
        end
        fitStage()
        local camera=workspace.CurrentCamera
        if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitStage) end
        local function makeImage(name,imageId,size,position,z)
            local image=Instance.new("ImageLabel",sg)
            image.Parent=stage; image.Name=name; image.AnchorPoint=Vector2.new(.5,.5); image.Size=size; image.Position=position
            image.BackgroundTransparency=1; image.Image=imageId; image.ScaleType=Enum.ScaleType.Fit; image.ImageTransparency=1; image.ZIndex=z or 3
            return image
        end
        local leftWing=makeImage("DragonIntroLeftWing","rbxassetid://83777907702768",UDim2.fromOffset(318,360),UDim2.fromOffset(196,248),2)
        local rightWing=makeImage("DragonIntroRightWing","rbxassetid://140189937498205",UDim2.fromOffset(318,360),UDim2.fromOffset(564,248),2)
        local bodyGlow=makeImage("DragonIntroBodyGlow","rbxassetid://139402289872576",UDim2.fromOffset(294,338),UDim2.fromOffset(380,255),3); bodyGlow.ImageColor3=Color3.fromRGB(235,242,255); bodyGlow.ImageTransparency=1
        local body=makeImage("DragonIntroBody","rbxassetid://139402289872576",UDim2.fromOffset(270,314),UDim2.fromOffset(380,255),4)
        local visuals={leftWing,rightWing,bodyGlow,body}
        for _,image in ipairs(visuals) do TweenService:Create(image,TweenInfo.new(.55,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{ImageTransparency=image==bodyGlow and .78 or 0}):Play() end
        task.delay(.18,function() if not Dragon_INTRO_DONE then playDragonIntroSongPreview(introSongIndex,8) end end)
        local finished=false; local started=os.clock(); local wingConn
        local function finish()
            if finished then return end
            finished=true; if wingConn then wingConn:Disconnect() end
            pcall(function()
                local sound=game:GetService("SoundService"):FindFirstChild("Dragon_IntroPreview")
                if sound then sound:Stop(); sound:Destroy() end
            end)
            for _,image in ipairs(visuals) do TweenService:Create(image,TweenInfo.new(.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{ImageTransparency=1}):Play() end
            task.delay(.38,function() if sg then sg:Destroy() end; dragonFinishIntro() end)
        end
        wingConn=game:GetService("RunService").RenderStepped:Connect(function()
            if finished then return end
            local elapsed=os.clock()-started
            local enter=math.clamp(elapsed/.8,0,1)
            local flap=(math.sin(math.max(0,elapsed-.7)*2.6)+1)*.5
            local spread=(.28+.72*flap)*enter
            local bob=math.sin(elapsed*2.2)*7
            leftWing.Position=UDim2.fromOffset(380-(112+112*spread),248+bob)
            rightWing.Position=UDim2.fromOffset(380+(112+112*spread),248+bob)
            leftWing.Rotation=-6-18*spread
            rightWing.Rotation=6+18*spread
            leftWing.Size=UDim2.fromOffset(318+16*spread,360+12*spread)
            rightWing.Size=UDim2.fromOffset(318+16*spread,360+12*spread)
            body.Position=UDim2.fromOffset(380,255+bob*.45)
            bodyGlow.Position=body.Position
            local pulse=.74+.08*(math.sin(elapsed*2.6)+1)*.5
            bodyGlow.ImageTransparency=pulse
        end)
        local skip=Instance.new("TextButton",sg); skip.Size=UDim2.new(1,0,1,0); skip.BackgroundTransparency=1; skip.Text=""; skip.ZIndex=10; skip.MouseButton1Click:Connect(finish)
        task.delay(8,finish)
        return
    end

    local IMG_URL  = "rbxassetid://77790957712601"
    local IMG_FILE = "dragon_intro.png"
    local DURATION = 15

    -- ========== FIXED getcustomasset LOADING ==========
    local imgAsset = ""

    local function downloadImage()
        local raw = nil

        local ok, result = pcall(function()
            return game:HttpGet(IMG_URL)
        end)
        if ok and result and #result > 100 then
            raw = result
        end

        if not raw and syn and syn.request then
            local res = syn.request({Url = IMG_URL, Method = "GET"})
            if res and res.Body and #res.Body > 100 then
                raw = res.Body
            end
        end

        if not raw then
            local reqFunc = (http and http.request) or request
            if reqFunc then
                local res = reqFunc({Url = IMG_URL, Method = "GET"})
                if res and res.Body and #res.Body > 100 then
                    raw = res.Body
                end
            end
        end

        return raw
    end

    local function getAssetFromFile(fileName)
        pcall(function()
            if isfile and isfile(fileName) then
                delfile(fileName)
            end
        end)

        local raw = downloadImage()
        if not raw then return "" end

        local writeOk = pcall(function()
            writefile(fileName, raw)
        end)
        if not writeOk then return "" end

        task.wait(0.05)

        local assetFuncs = {
            getcustomasset,
            getsynasset,
            getasset,
        }

        for _, func in ipairs(assetFuncs) do
            if typeof(func) == "function" then
                local success, asset = pcall(function()
                    return func(fileName)
                end)
                if success and type(asset) == "string" and asset ~= "" then
                    return asset
                end
            end
        end

        if typeof(getcustomasset) == "function" then
            local success, asset = pcall(function()
                return getcustomasset(fileName, true)
            end)
            if success and type(asset) == "string" and asset ~= "" then
                return asset
            end
        end

        return ""
    end

    -- Use the Roblox asset directly.  Loading it as an external file could
    -- stall the entire intro before its ScreenGui was even created.
    imgAsset = IMG_URL

    -- ========== INTRO SONG (fast cache + random playlist) ==========
    local introSound = nil
    local INTRO_SOUND_ENABLED = true
    task.spawn(function()
        if not INTRO_SOUND_ENABLED then return end
        pcall(function()
            -- User-selected intro playlist.
            local PLAYLIST = Dragon_INTRO_SONGS
            local pick = PLAYLIST[math.clamp(tonumber(introSongIndex) or 1,1,#PLAYLIST)]
            local SONG_URL, SONG_FILE, START_AT = pick.url, pick.file, pick.startAt or 0

            local function resolveAsset(fileName)
                local assetFuncs = {getcustomasset, getsynasset, getasset}
                for _, func in ipairs(assetFuncs) do
                    if typeof(func) == "function" then
                        local success, a = pcall(function() return func(fileName) end)
                        if success and type(a) == "string" and a ~= "" then
                            return a
                        end
                    end
                end
                if typeof(getcustomasset) == "function" then
                    local success, a = pcall(function() return getcustomasset(fileName, true) end)
                    if success and type(a) == "string" and a ~= "" then
                        return a
                    end
                end
                return ""
            end

            -- Prefer cached file (no re-download delay)
            local asset = ""
            if isfile and isfile(SONG_FILE) then
                asset = resolveAsset(SONG_FILE)
            end

            -- Download only if missing / cache failed
            if asset == "" then
                local raw = nil
                local ok, result = pcall(function() return game:HttpGet(SONG_URL) end)
                if ok and result and #result > 100 then
                    raw = result
                end
                if not raw then
                    local reqFunc = (http and http.request) or request or (syn and syn.request)
                    if reqFunc then
                        local res = reqFunc({Url = SONG_URL, Method = "GET"})
                        if res and res.Body and #res.Body > 100 then
                            raw = res.Body
                        end
                    end
                end
                if not raw then return end
                local writeOk = pcall(function() writefile(SONG_FILE, raw) end)
                if not writeOk then return end
                asset = resolveAsset(SONG_FILE)
            end
            if asset == "" then return end

            local SoundService = game:GetService("SoundService")
            -- kill any leftover intro sound
            pcall(function()
                local old = SoundService:FindFirstChild("Dragon_IntroSong")
                if old then old:Stop(); old:Destroy() end
            end)

            if Dragon_INTRO_DONE then return end
            introSound = Instance.new("Sound")
            introSound.Name = "Dragon_IntroSong"
            introSound.SoundId = asset
            introSound.Volume = 1
            introSound.Looped = false
            introSound.Parent = SoundService

            local played = false
            local function tryPlay()
                if played or Dragon_INTRO_DONE or not introSound or not introSound.Parent then return end
                played = true
                pcall(function()
                    introSound.TimePosition = START_AT
                    introSound:Play()
                end)
            end

            if introSound.IsLoaded then
                tryPlay()
            else
                introSound.Loaded:Connect(tryPlay)
                -- short fallback only (cache usually loads instantly)
                task.delay(0.35, tryPlay)
            end
        end)
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name           = "Dragon_Intro"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn   = false
    sg.DisplayOrder   = 100000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent = game:GetService("CoreGui") end) then
        sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local finished = false
    local imgLabel, backLogo, moon, glowRing, outerGlow, tapLbl, discordLbl = nil, nil, nil, nil, nil, nil, nil
    local skipBtn = nil

    local function destroyIntro()
        if finished then return end
        finished = true
        pcall(function()
            if skipBtn then skipBtn.Active=false; skipBtn.Visible=false end
            if sg then sg.Enabled=false end
        end)
        pcall(function()
            if introSound then introSound:Stop(); introSound:Destroy() end
        end)
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local targets = {imgLabel, backLogo, moon, glowRing, outerGlow, tapLbl, discordLbl}
        for _, obj in ipairs(targets) do
            if obj then
                pcall(function()
                    if obj:IsA("ImageLabel") then
                        TweenService:Create(obj, fadeInfo, {
                            ImageTransparency = 1,
                            Size = obj.Size - UDim2.new(0, 30, 0, 30)
                        }):Play()
                    elseif obj:IsA("TextLabel") then
                        TweenService:Create(obj, fadeInfo, {
                            TextTransparency = 1,
                            TextStrokeTransparency = 1
                        }):Play()
                    else
                        TweenService:Create(obj, fadeInfo, {
                            BackgroundTransparency = 1,
                            Size = obj.Size - UDim2.new(0, 25, 0, 25)
                        }):Play()
                    end
                end)
            end
        end
        -- fade chain trails
        pcall(function()
            local stage = sg and sg:FindFirstChild("ChainSpearStage")
            if stage then
                for _, d in ipairs(stage:GetDescendants()) do
                    if d:IsA("ImageLabel") then
                        TweenService:Create(d, fadeInfo, {ImageTransparency = 1}):Play()
                    end
                end
            end
        end)
        task.wait(0.25)
        pcall(function() sg:Destroy() end)
        dragonFinishIntro()
    end

    local dim = Instance.new("Frame", sg)
    dim.Size = UDim2.new(1,0,1,0)
    dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dim.BackgroundTransparency = 0.82
    dim.BorderSizePixel = 0
    dim.ZIndex = 1

    moon = Instance.new("ImageLabel", sg)
    moon.Name = "Moon"
    moon.Size = UDim2.new(0, 480, 0, 480)
    moon.Position = UDim2.new(0.5, 0, 0.5, -20)
    moon.AnchorPoint = Vector2.new(0.5, 0.5)
    moon.BackgroundTransparency = 1
    moon.Image = "rbxassetid://6031097222"
    moon.ImageTransparency = 0.62
    moon.ImageColor3 = Color3.fromRGB(210, 225, 255)
    moon.ZIndex = 2
    moon.ScaleType = Enum.ScaleType.Fit

    local moonGlow = Instance.new("Frame", sg)
    moonGlow.Size = UDim2.new(0, 520, 0, 520)
    moonGlow.Position = UDim2.new(0.5, 0, 0.5, -20)
    moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    moonGlow.BackgroundColor3 = Color3.fromRGB(160, 190, 255)
    moonGlow.BackgroundTransparency = 0.94
    moonGlow.BorderSizePixel = 0
    moonGlow.ZIndex = 1
    Instance.new("UICorner", moonGlow).CornerRadius = UDim.new(1, 0)

    outerGlow = Instance.new("Frame", sg)
    outerGlow.Size = UDim2.new(0, 0, 0, 0)
    outerGlow.Position = UDim2.new(0.5, 0, 0.5, -8)
    outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    outerGlow.BackgroundColor3 = Color3.fromRGB(140, 180, 255)
    outerGlow.BackgroundTransparency = 1
    outerGlow.BorderSizePixel = 0
    outerGlow.ZIndex = 3
    Instance.new("UICorner", outerGlow).CornerRadius = UDim.new(1, 0)

    glowRing = Instance.new("Frame", sg)
    glowRing.Size = UDim2.new(0, 0, 0, 0)
    glowRing.Position = UDim2.new(0.5, 0, 0.5, -8)
    glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
    glowRing.BackgroundColor3 = Color3.fromRGB(180, 210, 255)
    glowRing.BackgroundTransparency = 1
    glowRing.BorderSizePixel = 0
    glowRing.ZIndex = 4
    Instance.new("UICorner", glowRing).CornerRadius = UDim.new(1, 0)
    local glowStroke = Instance.new("UIStroke", glowRing)
    glowStroke.Color = Color3.fromRGB(200, 230, 255)
    glowStroke.Thickness = 2
    glowStroke.Transparency = 1

    imgLabel = Instance.new("ImageLabel", sg)
    imgLabel.Size = UDim2.new(0, 14, 0, 14)
    imgLabel.Position = UDim2.new(0.5, 0, 0.5, 70)
    imgLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    imgLabel.BackgroundTransparency = 1
    imgLabel.ScaleType = Enum.ScaleType.Fit
    imgLabel.ImageTransparency = 1
    imgLabel.ZIndex = 7
    if imgAsset ~= "" then
        imgLabel.Image = imgAsset
    else
        imgLabel.Image = IMG_URL
    end

    backLogo = Instance.new("ImageLabel", sg)
    backLogo.Name="IntroBackgroundLogo"
    backLogo.Size=UDim2.new(0,14,0,14)
    backLogo.Position=UDim2.new(0.5,0,0.5,-8)
    backLogo.AnchorPoint=Vector2.new(0.5,0.5)
    backLogo.BackgroundTransparency=1
    backLogo.ScaleType=Enum.ScaleType.Fit
    backLogo.Image=Dragon_INTRO_BACKGROUNDS[math.clamp(tonumber(introBackgroundIndex) or 1,1,#Dragon_INTRO_BACKGROUNDS)]
    backLogo.ImageTransparency=1
    backLogo.ZIndex=6
    task.delay(0.15, function()
        if imgLabel and imgLabel.Parent and (imgLabel.Image == "" or imgLabel.Image == nil) then
            imgLabel.Image = IMG_URL
        end
    end)

    task.spawn(function()
        TweenService:Create(imgLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 0
        }):Play()
        task.delay(0.05, function()
            TweenService:Create(imgLabel, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 560, 0, 560)
            }):Play()
            TweenService:Create(backLogo, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 610, 0, 610), ImageTransparency = 0.12
            }):Play()
        end)
        task.delay(0.7, function()
            TweenService:Create(imgLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 500, 0, 500)
            }):Play()
            TweenService:Create(backLogo, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 550, 0, 550)
            }):Play()
        end)
        task.delay(0.15, function()
            TweenService:Create(glowRing, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 300),
                BackgroundTransparency = 0.88
            }):Play()
            TweenService:Create(glowStroke, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.65
            }):Play()
        end)
        task.delay(0.25, function()
            TweenService:Create(outerGlow, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 390, 0, 390),
                BackgroundTransparency = 0.93
            }):Play()
        end)
    end)

    task.spawn(function()
        local t = 0
        while not finished do
            t = t + 0.016
            local floatY = math.sin(t * 0.7) * 11
            local breath = 1 + math.sin(t * 0.5) * 0.015
            local rot = math.sin(t * 0.25) * 0.9
            if imgLabel and imgLabel.Parent then
                imgLabel.Position = UDim2.new(0.5, 0, 0.5, 70 + floatY)
                imgLabel.Rotation = rot
                imgLabel.Size = UDim2.new(0, 500 * breath, 0, 500 * breath)
            end
            if backLogo and backLogo.Parent then
                backLogo.Position=UDim2.new(0.5,0,0.5,-8+floatY)
                backLogo.Rotation=rot
                backLogo.Size=UDim2.new(0,550*breath,0,550*breath)
            end
            if glowRing and glowRing.Parent then
                local pulse = 1 + math.sin(t * 0.65) * 0.02
                glowRing.Size = UDim2.new(0, 300 * pulse, 0, 300 * pulse)
                glowRing.Position = UDim2.new(0.5, 0, 0.5, -8 + floatY * 0.55)
                glowRing.BackgroundTransparency = 0.87 + math.sin(t * 0.8) * 0.035
            end
            if outerGlow and outerGlow.Parent then
                local pulse2 = 1 + math.sin(t * 0.45) * 0.025
                outerGlow.Size = UDim2.new(0, 390 * pulse2, 0, 390 * pulse2)
                outerGlow.Position = UDim2.new(0.5, 0, 0.5, -8 + floatY * 0.3)
            end
            if moon and moon.Parent then
                local my = math.sin(t * 0.22) * 7
                moon.Position = UDim2.new(0.5, 0, 0.5, -20 + my)
                moon.Rotation = t * 0.35
                moonGlow.Position = moon.Position
            end
            task.wait()
        end
    end)

    local function makeOrbiter(radius, size, speed, phase, color)
        local orb = Instance.new("Frame", sg)
        orb.Size = UDim2.new(0, size, 0, size)
        orb.AnchorPoint = Vector2.new(0.5, 0.5)
        orb.BackgroundColor3 = color
        orb.BackgroundTransparency = 0.5
        orb.BorderSizePixel = 0
        orb.ZIndex = 5
        Instance.new("UICorner", orb).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            local t = phase
            while orb and orb.Parent and not finished do
                t = t + 0.016 * speed
                local x = math.cos(t) * radius
                local y = math.sin(t) * radius * 0.7
                orb.Position = UDim2.new(0.5, x, 0.5, -8 + y)
                orb.BackgroundTransparency = 0.4 + math.abs(math.sin(t * 1.3)) * 0.35
                task.wait()
            end
        end)
    end
    makeOrbiter(155, 6, 0.65, 0, Color3.fromRGB(180, 210, 255))
    makeOrbiter(165, 5, 0.85, 1.8, Color3.fromRGB(200, 180, 255))
    makeOrbiter(145, 5, 0.55, 3.2, Color3.fromRGB(160, 240, 255))
    makeOrbiter(175, 4, 0.95, 4.5, Color3.fromRGB(255, 255, 255))

    -- ========== ADAPT-STYLE CHAIN TRAIL ROTORS ==========
    local TRAIL_COLOR = Color3.fromRGB(205, 215, 235)
    local TRAIL_IMG = "rbxassetid://118963313877514"
    local chainStage = Instance.new("Frame", sg)
    chainStage.Name = "ChainSpearStage"
    chainStage.AnchorPoint = Vector2.new(0.5, 0.5)
    chainStage.Position = UDim2.new(0.5, 0, 0.5, -8)
    chainStage.Size = UDim2.new(0, 280, 0, 280)
    chainStage.BackgroundTransparency = 1
    chainStage.ZIndex = 3
    local rotorData = {
        {rot=-1094.822,trans=0.998},
        {rot=-1095.4,trans=0.998},
        {rot=-1095.978,trans=0.996},
        {rot=-1096.515,trans=0.995},
        {rot=-1097.052,trans=0.993},
        {rot=-1097.548,trans=0.991},
        {rot=-1098.004,trans=0.988},
        {rot=-1098.419,trans=0.985},
        {rot=-1098.794,trans=0.982},
        {rot=-1099.128,trans=0.978},
        {rot=-1099.421,trans=0.973},
    }
    local rotors = {}
    for i, data in ipairs(rotorData) do
        local rotor = Instance.new("Frame", chainStage)
        rotor.Name = "ChainSpearRotor"..i
        rotor.AnchorPoint = Vector2.new(0.5, 0.5)
        rotor.Position = UDim2.new(0.5, 0, 0.5, 0)
        rotor.Size = UDim2.new(1, 0, 1, 0)
        rotor.BackgroundTransparency = 1
        rotor.Rotation = data.rot
        rotor.ZIndex = 3
        local trail = Instance.new("ImageLabel", rotor)
        trail.Name = "ChainSpearTrail"..i
        trail.AnchorPoint = Vector2.new(0.73, 0.02)
        trail.Position = UDim2.new(0.5, 0, 0.5, 0)
        trail.Size = UDim2.new(0.553, 0, 0.829, 0)
        trail.BackgroundTransparency = 1
        trail.Image = TRAIL_IMG
        trail.ImageColor3 = TRAIL_COLOR
        trail.ImageTransparency = data.trans
        trail.ScaleType = Enum.ScaleType.Fit
        trail.ZIndex = 3
        table.insert(rotors, {rotor=rotor, trail=trail, idx=i})
    end
    task.spawn(function()
        for _, r in ipairs(rotors) do
            task.delay((r.idx-1)*0.035, function()
                if finished or not r.trail or not r.trail.Parent then return end
                TweenService:Create(r.trail, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 0.12
                }):Play()
            end)
            task.spawn(function()
                local speed = 0.38 + (r.idx * 0.045)
                while not finished and r.rotor and r.rotor.Parent do
                    r.rotor.Rotation = r.rotor.Rotation + speed
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end)

    -- ========== TAP TO SKIP + DISCORD (pulse, non-copyable) ==========
    tapLbl = Instance.new("TextLabel", sg)
    tapLbl.Name = "TapAnywhere"
    tapLbl.AnchorPoint = Vector2.new(0.5, 0)
    tapLbl.Position = UDim2.new(0.5, 0, 0.5, 120)
    tapLbl.Size = UDim2.new(0, 280, 0, 22)
    tapLbl.BackgroundTransparency = 1
    tapLbl.Text = "tap to skip"
    tapLbl.Font = Enum.Font.Gotham
    tapLbl.TextSize = 14
    tapLbl.TextColor3 = Color3.fromRGB(220, 225, 235)
    tapLbl.TextTransparency = 1
    tapLbl.TextStrokeTransparency = 0.5
    tapLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tapLbl.ZIndex = 12

    discordLbl = Instance.new("TextLabel", sg)
    discordLbl.Name = "DiscordInvite"
    discordLbl.AnchorPoint = Vector2.new(0.5, 0)
    discordLbl.Position = UDim2.new(0.5, 0, 0.5, 148)
    discordLbl.Size = UDim2.new(0, 320, 0, 20)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/dragonhub"
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 13
    discordLbl.TextColor3 = Color3.fromRGB(180, 200, 255)
    discordLbl.TextTransparency = 1
    discordLbl.TextStrokeTransparency = 0.55
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.ZIndex = 12
    -- non-copyable (display only)
    discordLbl.Active = false
    discordLbl.Selectable = false

    -- Minimal intro: only the requested Snow logo is visible.
    dim.Visible=false
    moon.Visible=false
    moonGlow.Visible=false
    outerGlow.Visible=false
    glowRing.Visible=false
    chainStage.Visible=false
    tapLbl.Visible=false
    discordLbl.Visible=false

    task.delay(0.55, function()
        if finished then return end
        if tapLbl and tapLbl.Parent then
            TweenService:Create(tapLbl, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.15
            }):Play()
        end
        if discordLbl and discordLbl.Parent then
            TweenService:Create(discordLbl, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.25
            }):Play()
        end
    end)

    task.spawn(function()
        while not finished and tapLbl and tapLbl.Parent do
            TweenService:Create(tapLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.48
            }):Play()
            task.wait(0.65)
            if finished then break end
            TweenService:Create(tapLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.05
            }):Play()
            task.wait(0.65)
        end
    end)

    skipBtn = Instance.new("TextButton", sg)
    skipBtn.Size = UDim2.new(1,0,1,0)
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.ZIndex = 30
    skipBtn.Active = true
    skipBtn.AutoButtonColor = false
    skipBtn.MouseButton1Click:Connect(function()
        if not finished then destroyIntro() end
    end)

    task.delay(DURATION, function()
        if not finished then destroyIntro() end
    end)
end)

-- Safety release: a failed cosmetic tween must never leave HUD elements blocked.
task.delay(17, dragonFinishIntro)

-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
SnowSkyThemeTag = "SnowSkyTheme"
SnowCurrentSkyTheme = "Night"
SnowSkyPresets = {
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
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
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
SnowSkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function snowSkyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function SnowApplySkyTheme(mode)
    -- Snow sky handling: remove only Snow's prior sky instances, then
    -- build one predictable Sky + Atmosphere from the selected preset.
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(SnowSkyThemeTag) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(SnowSkyThemeTag) then pcall(function() child:Destroy() end) end end end
    local preset=SnowSkyPresets[mode]
    if not preset or preset.kind=="off" then
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=true
        SnowCurrentSkyTheme="Off"
        return
    end
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=snowSkyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=snowSkyColor(preset.ambient) end
    local atm=Instance.new("Atmosphere"); atm:SetAttribute(SnowSkyThemeTag,true)
    atm.Density=0.35; atm.Color=Lighting.Ambient; atm.Decay=Lighting.OutdoorAmbient; atm.Parent=Lighting
    local skyInst=Instance.new("Sky"); skyInst:SetAttribute(SnowSkyThemeTag,true)
    skyInst.StarCount=(mode=="Galaxy" or mode=="Deep Space") and 10000 or 2000; skyInst.Parent=Lighting
    SnowCurrentSkyTheme=mode
end

-- Full-color themes build on the white base, then recolor every UI surface,
-- the title artwork and the selected background with one shared palette.
function SnowApplyFullColorTheme(name,rebuildMobile)
    name="BIANCO"
    if name=="BIANCO" or name=="AZZURRO" then return SnowApplyUiTheme(name,rebuildMobile) end
    local accent=SnowUiThemePalette[name]
    if not accent then return end
    SnowApplyUiTheme("BIANCO",false)
    snowUiThemeName=name; snowThemeName=name; SnowThemeColors[name]=accent
    -- Colored themes never fall back to Snow's original azure wallpapers.
    -- They use the provided collection and retain a separate selection index.
    if SnowColorThemeBackgrounds then
        SnowThemeBackgrounds[name]=SnowColorThemeBackgrounds
        BG_IMAGE_URLS=SnowColorThemeBackgrounds; bgLoadedAssets={}
        backgroundIndex=math.clamp(math.floor((SnowThemeBackgroundIndex and SnowThemeBackgroundIndex[name]) or 1),1,#BG_IMAGE_URLS)
    end
    applySnowTheme()
    -- SnowApplyUiTheme first paints the old white base; repaint all existing
    -- overhead labels afterward so Discord and Speed match custom themes too.
    for _,item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BillboardGui") and (item.Name:find("Dragon") or item.Name=="SnowEnemySpeed") then
            for _,label in ipairs(item:GetDescendants()) do
                if label:IsA("TextLabel") and (label.Name=="Discord" or label.Name=="SpeedLabel" or label.Name=="RagdollCountdown") then label.TextColor3=accent end
                if label:IsA("ImageLabel") and label.Name=="DragonLogo" then label.ImageColor3=accent end
                if label:IsA("UIStroke") then label.Color=accent end
            end
        end
    end
    -- White theme uses a genuinely monochrome ESP: labels, chams and outlines
    -- are all white instead of retaining cyan from the Azure palette.
    if snowUiThemeName=="BIANCO" then
        for _,item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Highlight") and (item.Name:find("DragonESP") or item.Name=="DragonChams") then
                item.FillColor=Color3.fromRGB(255,255,255); item.OutlineColor=Color3.fromRGB(255,255,255)
            elseif item:IsA("BillboardGui") and (item.Name:find("DragonESP") or item.Name=="SnowEnemySpeed") then
                for _,label in ipairs(item:GetDescendants()) do if label:IsA("TextLabel") then label.TextColor3=Color3.fromRGB(255,255,255) end end
            end
        end
    else
        -- Restore Azure ESP immediately after returning from the white theme;
        -- otherwise previously-created highlights keep their old white paint.
        for _,item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Highlight") and (item.Name:find("DragonESP") or item.Name=="DragonChams") then
                item.FillColor=Color3.fromRGB(12,65,84); item.OutlineColor=tint
            elseif item:IsA("BillboardGui") and (item.Name:find("DragonESP") or item.Name=="SnowEnemySpeed") then
                for _,label in ipairs(item:GetDescendants()) do if label:IsA("TextLabel") then label.TextColor3=tint end end
            end
        end
        for _,box in pairs(SnowExtraESP and SnowExtraESP.boxData or {}) do pcall(function() box.Color=tint end) end
        for _,line in pairs(SnowExtraESP and SnowExtraESP.lineData or {}) do pcall(function() line.Color=tint end) end
    end
    if bgImageRef then bgImageRef.ImageColor3=accent; applyBackgroundImage(backgroundIndex) end
    if GuiRefs then
        for _,refName in ipairs({"snowTitle","reopenTitle"}) do
            local ref=GuiRefs[refName]
            if ref and (ref:IsA("ImageLabel") or ref:IsA("ImageButton")) then ref.ImageColor3=accent end
        end
        local content=GuiRefs.contentFrame
        if content then
            for _,item in ipairs(content:GetDescendants()) do
                if item.Name=="SelectedTitlePreview" and (item:IsA("ImageLabel") or item:IsA("ImageButton")) then item.ImageColor3=accent end
            end
        end
    end
    if SnowRefreshHitCircleTheme then SnowRefreshHitCircleTheme() end
    if SnowRefreshBackgroundCarousel then SnowRefreshBackgroundCarousel() end
    if SnowRefreshBackgroundListVisual then SnowRefreshBackgroundListVisual() end
    if SnowRefreshThemePalette then SnowRefreshThemePalette() end
    if SnowHideUiBorders then SnowHideUiBorders() end
    if rebuildMobile and mobileButtonsEnabled and buildMobileButtons then buildMobileButtons() end
end

function SnowHideUiBorders()
    if not (GuiRefs and GuiRefs.hub) then return end
    local accent=SnowGetUiThemeColor()
    for _,item in ipairs(GuiRefs.hub:GetDescendants()) do
        if item:IsA("UIStroke") then
            local parentName=item.Parent and item.Parent.Name or ""
            -- The background carousel manages this one itself: only the
            -- selected photo has a visible theme-colored outline.
            if not parentName:match("^BackgroundCard_") then item.Transparency=1 end
        end
    end
    if GuiRefs.tabSeparator then GuiRefs.tabSeparator.BackgroundColor3=accent end
    if GuiRefs.closeButton then GuiRefs.closeButton.TextColor3=Color3.fromRGB(255,255,255) end
end

-- ============================================================
-- STATE
-- ============================================================
TS=TweenService
LP=Players.LocalPlayer

-- Robust image loader (PC + mobile executors)
function loadCustomImageAsset(url, fileName)
    if not url or url == "" then return "" end
    fileName = fileName or ("snow_img_" .. tostring(math.floor(tick()*1000)) .. ".png")
    local function resolve(path)
        local funcs = {getcustomasset, getsynasset, getasset}
        for _, f in ipairs(funcs) do
            if typeof(f) == "function" then
                local ok, a = pcall(function() return f(path) end)
                if ok and type(a) == "string" and a ~= "" then return a end
            end
        end
        if typeof(getcustomasset) == "function" then
            local ok, a = pcall(function() return getcustomasset(path, true) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
        return ""
    end
    -- cache hit
    if isfile and isfile(fileName) then
        local a = resolve(fileName)
        if a ~= "" then return a end
    end
    local raw = nil
    pcall(function()
        local body = game:HttpGet(url)
        if body and #body > 80 then raw = body end
    end)
    if not raw then
        local req = (syn and syn.request) or (http and (http.request or http.Request)) or request or http_request
        if req then
            local ok, res = pcall(function()
                return req({Url = url, Method = "GET", Headers = {["User-Agent"]="Mozilla/5.0"}})
            end)
            if ok and type(res) == "table" then
                raw = res.Body or res.body or res.Data or res.data
            elseif ok and type(res) == "string" then
                raw = res
            end
        end
    end
    if not raw or #raw < 80 then return url end -- last resort: raw url
    pcall(function()
        if writefile then writefile(fileName, raw) end
    end)
    task.wait(0.05)
    local asset = resolve(fileName)
    if asset ~= "" then return asset end
    return url
end


NS,CS=60,30
LAGGER_SPEED=40
LAGGER_CARRY_SPEED=20
speedSystem="V2"
mobileButtonFrames={}
mobileButtonVisibility={}
carrySpeedActive = false
noCamCollisionEnabled=false
laggerModeEnabled = false
antiDieEnabled = true
antiRagdollEnabled,infJumpEnabled=false,false
e01AlertEnabled=false
e01AlertScale=1
hidePingWarner=true
medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
batCounterMode="V1"
medusaDebounce,medusaLastUsed,dropActive=false,0,false
autoAfterDropEnabled=false
autoAfterDropMode="AIMBOT"
autoAfterDropWasCarrying=false
batSoundsEnabled=false
medusaSkinMode="NONE"
medusaSoundsEnabled=false
Dragon={antiKick=true,brainrot=false,tpBat=false,tpBatAntiDie=true,tpBatAntiVoid=false,tpBatFreeCamera=false,tpBatNoCamCollision=false,tpBatAutoDisableOnHit=false,tpBatSwingCooldown=0.12,tpBatCurrentTarget=nil,tpBatHittingCooldown=false,tpBatHitTarget=nil,tpBatHitTargetRagdolled=false,forceHit=false,bodyLock=false,bodyLockMode="PERM",bodyLockRange=60,enemyRagdollTimerEnabled=false,batV2=false,tpConn=nil,v2Conn=nil,v2Rot=nil,hitCD=false,v2CD=false,alertLayout={pingVisible=false,e01Visible=false}}
autoLeftEnabled,autoRightEnabled=false,false
autoPlayMode=false
autoPlayRouteMode="FULL"
autoPlayEnabled=false
autoPlaySide=nil
autoLeftSetVisual,autoRightSetVisual=nil,nil

speedLabel=nil
autoBatEnabled=false
batV2Enabled=false
batV2Speed=56.5
batV2Conn=nil
batV2LastSwing=0
mirrorTPDownEnabled=false
MIRROR_TP_DROP_THRESHOLD=3
MIRROR_TP_DOWN_Y=-7.00
mirrorTPPreviousY={}
mirrorTPLastTeleport=0

function mirrorTPCombatActive()
    return (autoBatEnabled==true) or (batV2Enabled==true) or (Dragon and Dragon.batV2==true)
end

function mirrorTPTeleportDown()
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 then return end
    local now=tick()
    if now-(mirrorTPLastTeleport or 0)<0.08 then return end
    mirrorTPLastTeleport=now
    local _,yaw=root.CFrame:ToEulerAnglesYXZ()
    root.CFrame=CFrame.new(root.Position.X,MIRROR_TP_DOWN_Y,root.Position.Z)*CFrame.Angles(0,yaw,0)
    root.Velocity=Vector3.zero
    pcall(function() root.AssemblyLinearVelocity=Vector3.zero end)
end

RunService.Heartbeat:Connect(function()
    if not mirrorTPDownEnabled or not mirrorTPCombatActive() then
        if next(mirrorTPPreviousY) then table.clear(mirrorTPPreviousY) end
        return
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local root=plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentY=root.Position.Y
                local previousY=mirrorTPPreviousY[plr.UserId]
                if previousY and previousY-currentY>=MIRROR_TP_DROP_THRESHOLD then
                    pcall(mirrorTPTeleportDown)
                    table.clear(mirrorTPPreviousY)
                    return
                end
                mirrorTPPreviousY[plr.UserId]=currentY
            end
        end
    end
end)
-- SNOW.VS theme colors
SnowThemeColors={
    WHITE  = Color3.fromRGB(255,255,255),
    PURPLE = Color3.fromRGB(207,159,255),
    BLUE   = Color3.fromRGB(58,128,245),
    RED    = Color3.fromRGB(232,52,68),
    PINK   = Color3.fromRGB(255,105,180),
    YELLOW = Color3.fromRGB(255,214,0),
    GREY   = Color3.fromRGB(90,90,90),
    FOREST = Color3.fromRGB(46,139,87),
}
SnowThemeColors.AZZURRO=Color3.fromRGB(80,215,255)
SnowUiThemePalette={
    BIANCO=Color3.fromRGB(255,255,255),
    AZZURRO=Color3.fromRGB(80,215,255),
}
snowThemeName="WHITE"
-- Visual theme for the menu artwork and Dragon overlays.  This is separate
-- from the legacy accent palette above so existing UI behavior stays intact.
function SnowGetUiThemeColor()
    return SnowUiThemePalette[snowUiThemeName] or Color3.fromRGB(255,255,255)
end
function SnowGetMobileActiveColor()
    return SnowGetUiThemeColor()
end
function getSnowAccent()
    return SnowThemeColors[snowThemeName] or SnowThemeColors.WHITE
end
function _snowBlend(a,b,t)
    t=math.clamp(t or 0.5,0,1)
    return Color3.new(a.R+(b.R-a.R)*t, a.G+(b.G-a.G)*t, a.B+(b.B-a.B)*t)
end
function applySnowTheme()
    local accent=getSnowAccent()
    pcall(function()
        -- rebuild palette from accent (full menu recolor)
        if C then
            local dark=Color3.fromRGB(6,6,6)
            local darker=Color3.fromRGB(3,3,3)
            C.blue=accent
            C.blueDim=_snowBlend(accent,Color3.fromRGB(40,40,40),0.55)
            C.blueDark=_snowBlend(darker,accent,0.12)
            C.bg=_snowBlend(dark,accent,0.06)
            C.bgDark=_snowBlend(darker,accent,0.04)
            C.row=_snowBlend(Color3.fromRGB(16,16,16),accent,0.10)
            C.input=_snowBlend(Color3.fromRGB(16,16,16),accent,0.08)
            C.divider=_snowBlend(Color3.fromRGB(32,32,32),accent,0.25)
            C.text=Color3.fromRGB(255,255,255)
            C.textDim=_snowBlend(Color3.fromRGB(160,160,160),accent,0.25)
            C.textMuted=_snowBlend(Color3.fromRGB(100,100,100),accent,0.20)
            C.white=Color3.fromRGB(255,255,255)
        end

        local function paintTree(root)
            if not root then return end
            for _,d in ipairs(root:GetDescendants()) do
                -- title image
                if d.Name=="SnowTitle" and (d:IsA("ImageLabel") or d:IsA("ImageButton")) then
                    d.ImageColor3=Color3.fromRGB(255,255,255)
                end
                -- strokes → accent / tinted divider
                if d:IsA("UIStroke") then
                    local pn=d.Parent and d.Parent.Name or ""
                    if pn=="LogoCircle" or pn=="SnowOpenPill" or pn=="MiniBtn" then
                        d.Color=accent
                    elseif d.Thickness and d.Thickness>=1.5 then
                        d.Color=_snowBlend(Color3.fromRGB(45,45,45),accent,0.55)
                    else
                        d.Color=_snowBlend(C.divider,accent,0.35)
                    end
                end
                -- frames / buttons with dark row-like colors
                if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
                    local bg=d.BackgroundColor3
                    if bg then
                        local r,g,b=bg.R*255,bg.G*255,bg.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        -- near-neutral dark UI → theme tint
                        if sat<35 and avg<55 then
                            d.BackgroundColor3=_snowBlend(Color3.fromRGB(r,g,b),accent,0.14)
                        elseif sat<40 and avg<90 then
                            d.BackgroundColor3=_snowBlend(Color3.fromRGB(r,g,b),accent,0.18)
                        end
                    end
                end
                -- labels: dim text gets accent wash; active/accent text → accent
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    local tc=d.TextColor3
                    if tc then
                        local r,g,b=tc.R*255,tc.G*255,tc.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        if sat<30 and avg>120 and avg<200 then
                            d.TextColor3=_snowBlend(Color3.fromRGB(r,g,b),accent,0.35)
                        elseif sat<25 and avg>=200 then
                            -- keep near-white
                        elseif sat>40 and avg>100 then
                            -- already colored → pull toward accent
                            d.TextColor3=_snowBlend(tc,accent,0.65)
                        end
                    end
                end
                -- tab / selected pills often use UIGradient or solid accent
                if d:IsA("UIGradient") and d.Parent then
                    -- leave gradients; strokes handle most chrome
                end
            end
        end

        if GuiRefs then
            if GuiRefs.outer then
                GuiRefs.outer.BackgroundColor3=C.bgDark
                paintTree(GuiRefs.outer)
            end
            if GuiRefs.inner then
                GuiRefs.inner.BackgroundColor3=C.bg
                paintTree(GuiRefs.inner)
            end
            if GuiRefs.chromeGroup then paintTree(GuiRefs.chromeGroup) end
            if GuiRefs.hub then paintTree(GuiRefs.hub) end
            if GuiRefs.bgGrad then
                GuiRefs.bgGrad.BackgroundColor3=C.bgDark
            end
            if GuiRefs.snowTitle then
                if GuiRefs.snowTitle:IsA("ImageLabel") or GuiRefs.snowTitle:IsA("ImageButton") then
                    GuiRefs.snowTitle.ImageColor3=Color3.fromRGB(255,255,255)
                elseif GuiRefs.snowTitle:IsA("TextLabel") then
                    GuiRefs.snowTitle.TextColor3=accent
                end
            end
            -- tab buttons
            if GuiRefs.categoryList then paintTree(GuiRefs.categoryList) end
            if GuiRefs.contentFrame then paintTree(GuiRefs.contentFrame) end
        end

        -- mobile pad
        if mobGuiRef then
            for _,d in ipairs(mobGuiRef:GetDescendants()) do
                if d:IsA("UIStroke") then d.Color=accent end
                if d:IsA("ImageLabel") and (d.Name=="BtnImage" or d.Name=="MobileBackgroundImage") then
                    d.ImageColor3=accent
                end
                if d:IsA("Frame") or d:IsA("TextButton") then
                    local bg=d.BackgroundColor3
                    if bg then
                        local r,g,b=bg.R*255,bg.G*255,bg.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        if sat<40 and avg<80 then
                            d.BackgroundColor3=_snowBlend(Color3.fromRGB(r,g,b),accent,0.16)
                        end
                    end
                end
            end
        end

        -- steal bar
        if stealBarFrame then
            local st=stealBarFrame:FindFirstChildOfClass("UIStroke")
            if st then st.Color=accent end
            for _,d in ipairs(stealBarFrame:GetDescendants()) do
                if d:IsA("UIStroke") then d.Color=_snowBlend(d.Color,accent,0.5) end
            end
        end
    end)
end


aimbotAfterHitEnabled=false
aimbotAfterHitDebounce=false
autoSwingEnabled=true
autoMoveSwingEnabled=false
autoMoveSwingInterval=0.3
_alSwingDebounce=false
_arSwingDebounce=false
autoBatSetVisual=nil
resetAutoBatMotion=nil
setBatCounterVisual=nil
startBatCounter,stopBatCounter = nil,nil
antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
fpsBoostEnabled=false
fpsCapValue=60
-- FPS limiting is opt-in.  A fresh install remains uncapped until enabled.
fpsCapEnabled=false
function DragonApplyFpsCap()
    -- Delta/mobile and PC executors use one of these common FPS-cap APIs.
    -- Unsupported executors simply keep their own default FPS behaviour.
    local cap=math.clamp(math.floor(tonumber(fpsCapValue) or 60),60,1000)
    fpsCapValue=cap
    local requestedCap=fpsCapEnabled and cap or 0
    -- pairs is intentional: a missing first API must not hide a later one.
    for _,setter in pairs({setfpscap,set_fps_cap,setfpslimit,set_fps_limit}) do
        if type(setter)=="function" then
            local ok=pcall(function() setter(requestedCap) end)
            if ok then return true end
        end
    end
    return false
end
snowVisualUpdateClock={}
function snowVisualUpdateDue(name,interval)
    -- Optimize is Dragon's own lightweight profile.  It never turns on Anti Lag
    -- or Script Optimizer; it simply reduces non-critical Dragon visual refreshes.
    local lightweight=DragonPerformanceProfile=="OPTIMIZE"
    if not fpsBoostEnabled and not lightweight then return true end
    if lightweight then interval=math.max(interval or 0,0.30) end
    local now=os.clock(); local last=snowVisualUpdateClock[name] or 0
    if now-last<interval then return false end
    snowVisualUpdateClock[name]=now
    return true
end
antiLagQueue={}
antiLagQueueHead=1
antiLagQueued=setmetatable({}, {__mode="k"})
antiLagWorker=nil
antiLagEffectState=setmetatable({}, {__mode="k"})
antiLagTerrainDecoration=nil
stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
stretchRezScale=2
unwalkSavedAnimate,_anyKeyListening=nil,false
autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
tpDownMethod="NORMAL"
tpDownSlowFallActive=false
tpDownZigZagSide=1
tpDownJumpLocked=false
guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
uiAutoFadeEnabled=false
tabsPosition="TOP"
collapsedTabMode="RIGHT"
colorfulGraphicsEnabled=false
motionBlurEnabled=false
snowColorfulEffect=nil
snowMotionBlur=nil
logoCircleEnabled=false
logoCircleRef=nil
mobileButtonsSize=80
snowGuiPosition=nil
snowGuiScale=0.70
circleButtonsEnabled=false
hitCircleEnabled=false
SnowHitCircle={part=nil,conn=nil,radius=8}
stealBarFrame = nil
stealBarScale = 1.0 -- size multiplier for steal bar
stealBarLocked = false
stealBarHidden = false
stealBarBackgroundUrl = ""
-- Persisted independently from the scale so resizing does not reset the bar.
stealBarPosition = nil
stealBarResetRequested = false

-- Scale is also checkpointed separately: mobile taps rebuild the bar straight
-- away, and a dedicated, very small write is much less likely to be lost than
-- the full settings file on mobile executors.
local function saveStealBarScale()
    local scale=math.clamp(tonumber(stealBarScale) or 1,0.7,1.8)
    stealBarScale=scale
    if not writefile then return end
    pcall(function()
        writefile(Dragon_STEALBAR_SIZE_FILE,HS:JSONEncode({scale=scale}))
    end)
end

local function loadStealBarScale()
    if not (isfile and readfile and isfile(Dragon_STEALBAR_SIZE_FILE)) then return end
    pcall(function()
        local saved=HS:JSONDecode(readfile(Dragon_STEALBAR_SIZE_FILE))
        if type(saved)=="table" and type(saved.scale)=="number" then
            stealBarScale=math.clamp(saved.scale,0.7,1.8)
        end
    end)
end
mobBtnRefs={}
mobGuiRef=nil
fovValue=80
-- The 120 preset becomes 180; keep a single 180 entry.
fovOptions={80,180}
fovIndex=1
laggerModePillRef=nil
carryModePillRef=nil
autoSwitchSpeedEnabled=false
autoCarryMode="ON_PICKUP"
autoCarryStealRange=10
animPackEnabled=false
animPackName="OFF"
headlessEnabled=false
headlessState=setmetatable({}, {__mode="k"})
korbloxEnabled=false
korbloxMode="OFF"
korbloxLastMode="RIGHT"
-- Cosmetic Bat skin state.  NONE keeps the game's original Bat untouched.
batSkinMode="NONE"
swordColorMode="DEFAULT"
swordColors={
    DEFAULT=Color3.fromRGB(70,190,255),
    ABYSS_BLUE=Color3.fromRGB(0,40,150),
    VENOM_GREEN=Color3.fromRGB(20,255,50),
    ROYAL_GOLD=Color3.fromRGB(255,200,0),
    VELVET_ROSE=Color3.fromRGB(220,20,100),
    CRIMSON_NIGHT=Color3.fromRGB(90,0,20),
}
batSkinOriginal=setmetatable({}, {__mode="k"})
batSkinAppliedTool=nil
batSkinAppliedMode=nil
batSkinSoundIds={SCYTHE="rbxassetid://9113305311"}
SnowBatSounds={conns={},custom=nil}
medusaSkinOriginal=setmetatable({}, {__mode="k"})
medusaSkinAppliedTool=nil
medusaSkinAppliedMode=nil
SnowMedusaSounds={conns={},custom=nil}
HEADLESS_MESH_ID = "rbxassetid://1095708"
KORBLOX_MESH_ID = "rbxassetid://101851696"
KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

-- Snow Speed Bypass: isolated state and names, without external-script globals.
SnowSpeedBypass=SnowSpeedBypass or {enabled=false,payload=nil,worker=nil,power=100000}
function SnowSpeedBypass.buildPayload(power)
    local depth=90
    local root,branch={},{{}}
    local cursor=branch[1]
    for _=1,depth do local child={}; table.insert(cursor,child); cursor=child end
    for _=1,math.floor((tonumber(power) or 100000)/(depth+2)) do table.insert(root,branch) end
    return root
end
function SnowSpeedBypass.setEnabled(on)
    local state=SnowSpeedBypass
    if state.enabled==on then return end
    state.enabled=on
    if on then
        state.payload=SnowSpeedBypass.buildPayload(state.power)
        local networkClient=game:GetService("NetworkClient")
        pcall(function() networkClient:SetOutgoingKBPSLimit(math.huge) end)
        state.worker=task.spawn(function()
            while state.enabled do
                pcall(function()
                    local remote=game:FindFirstChild("RobloxReplicatedStorage") and game.RobloxReplicatedStorage:FindFirstChild("SetPlayerBlockList")
                    if remote then remote:FireServer(state.payload) end
                end)
                task.wait(0.12)
            end
        end)
    else
        if state.worker then pcall(function() task.cancel(state.worker) end); state.worker=nil end
        state.payload=nil
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
    end
end

-- The Misc panel opens the original Snow Bypass interface; only its own controls enable it.
function SnowSpeedBypass.openGui()
    local playerGui=LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
    local existing=playerGui:FindFirstChild("SnowSpeedBypassGui")
    if existing then
        existing.Enabled=true
        local main=existing:FindFirstChild("Main")
        local tab=existing:FindFirstChild("SnowReopenTab")
        if main then main.Visible=true end
        if tab then tab.Visible=false end
        if SnowSpeedBypass.refreshGui then SnowSpeedBypass.refreshGui() end
        return
    end
    local config=SnowSpeedBypass.uiConfig or {Power=SnowSpeedBypass.power,Keybind="V",AutoOnSteal=false,BackgroundIndex=1}
    SnowSpeedBypass.uiConfig=config
    local backgrounds={"rbxassetid://86451307251942","rbxassetid://71276441402938","rbxassetid://119119672372597","rbxassetid://131508475551625","rbxassetid://130353905329767","rbxassetid://124161688439676","rbxassetid://97405075268024","rbxassetid://89839524050543"}
    local function corner(object,radius) local c=Instance.new("UICorner",object); c.CornerRadius=UDim.new(0,radius) end
    local function tween(object,properties) TweenService:Create(object,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties):Play() end
    local gui=Instance.new("ScreenGui",playerGui)
    gui.Name="SnowSpeedBypassGui"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local W,H=300,175
    local main=Instance.new("Frame",gui)
    main.Name="Main"; main.Size=UDim2.fromOffset(W,H); main.Position=UDim2.new(.5,-W/2,.5,-H/2); main.BackgroundColor3=Color3.fromRGB(16,20,28); main.BorderSizePixel=0; main.ClipsDescendants=true; main.Active=true; corner(main,14)
    local bg=Instance.new("ImageLabel",main)
    bg.Size=UDim2.fromScale(1,1); bg.BackgroundTransparency=1; bg.BorderSizePixel=0; bg.Image=backgrounds[config.BackgroundIndex]; bg.ScaleType=Enum.ScaleType.Crop; bg.ZIndex=0; corner(bg,14)
    local dim=Instance.new("Frame",main)
    dim.Size=UDim2.fromScale(1,1); dim.BackgroundColor3=Color3.fromRGB(10,14,22); dim.BackgroundTransparency=.48; dim.BorderSizePixel=0; dim.ZIndex=1; corner(dim,14)
    local function glass(size,position)
        local item=Instance.new("Frame",main); item.Size=size; item.Position=position; item.BackgroundColor3=Color3.fromRGB(255,255,255); item.BackgroundTransparency=.86; item.BorderSizePixel=0; item.ZIndex=4; corner(item,12)
        local line=Instance.new("UIStroke",item); line.Color=Color3.fromRGB(255,255,255); line.Transparency=.82; line.Thickness=1
        return item
    end
    local title=Instance.new("ImageLabel",main)
    title.Name="TitleArtwork"; title.Size=UDim2.fromOffset(160,52); title.Position=UDim2.fromOffset(12,1); title.BackgroundTransparency=1; title.BorderSizePixel=0; title.Image="rbxassetid://85917371495739"; title.ScaleType=Enum.ScaleType.Fit; title.ZIndex=6
    -- The minus only collapses the window into the reopen tab.  The X to its
    -- right is the explicit final close and can be reopened from the main GUI.
    local collapseButton=Instance.new("TextButton",main)
    collapseButton.Position=UDim2.fromOffset(240,14); collapseButton.Size=UDim2.fromOffset(20,20); collapseButton.BackgroundColor3=Color3.fromRGB(80,215,255); collapseButton.BackgroundTransparency=.62; collapseButton.BorderSizePixel=0; collapseButton.Text="−"; collapseButton.TextColor3=Color3.fromRGB(255,255,255); collapseButton.Font=Enum.Font.GothamBold; collapseButton.TextSize=16; collapseButton.AutoButtonColor=false; collapseButton.ZIndex=8; corner(collapseButton,7)
    local closeButton=Instance.new("TextButton",main)
    closeButton.Position=UDim2.fromOffset(264,14); closeButton.Size=UDim2.fromOffset(20,20); closeButton.BackgroundColor3=Color3.fromRGB(255,92,104); closeButton.BackgroundTransparency=.55; closeButton.BorderSizePixel=0; closeButton.Text="X"; closeButton.TextColor3=Color3.fromRGB(255,255,255); closeButton.Font=Enum.Font.GothamBold; closeButton.TextSize=12; closeButton.AutoButtonColor=false; closeButton.ZIndex=8; corner(closeButton,7)
    local reopenTab=Instance.new("ImageButton",gui)
    reopenTab.Name="SnowReopenTab"; reopenTab.Position=UDim2.new(0,14,.5,-15); reopenTab.Size=UDim2.fromOffset(160,38); reopenTab.BackgroundColor3=Color3.fromRGB(0,0,0); reopenTab.BackgroundTransparency=.08; reopenTab.BorderSizePixel=0; reopenTab.Image="rbxassetid://85917371495739"; reopenTab.ImageColor3=Color3.fromRGB(255,255,255); reopenTab.ScaleType=Enum.ScaleType.Fit; reopenTab.Visible=false; reopenTab.ZIndex=20; corner(reopenTab,19)
    collapseButton.MouseButton1Click:Connect(function()
        reopenTab.Position=main.Position
        main.Visible=false
        reopenTab.Visible=true
        if SnowSpeedBypass.refreshPanel then SnowSpeedBypass.refreshPanel() end
    end)
    closeButton.MouseButton1Click:Connect(function()
        -- Closing from inside the bypass GUI always stops an active bypass too.
        if SnowSpeedBypass.enabled then SnowSpeedBypass.setEnabled(false) end
        main.Visible=false
        reopenTab.Visible=false
        gui.Enabled=false
        if SnowSpeedBypass.refreshGui then SnowSpeedBypass.refreshGui() end
        if SnowSpeedBypass.refreshPanel then SnowSpeedBypass.refreshPanel() end
    end)
    reopenTab.MouseButton1Click:Connect(function() reopenTab.Visible=false; main.Position=reopenTab.Position; main.Visible=true end)
    local powerRow=glass(UDim2.new(1,-20,0,28),UDim2.fromOffset(10,61))
    local powerLabel=Instance.new("TextLabel",powerRow)
    powerLabel.Size=UDim2.fromOffset(54,28); powerLabel.Position=UDim2.fromOffset(10,0); powerLabel.BackgroundTransparency=1; powerLabel.Text="POWER"; powerLabel.TextColor3=Color3.fromRGB(210,215,225); powerLabel.Font=Enum.Font.GothamBold; powerLabel.TextSize=10; powerLabel.TextXAlignment=Enum.TextXAlignment.Left; powerLabel.ZIndex=6
    local powerBox=Instance.new("TextBox",powerRow)
    powerBox.Size=UDim2.fromOffset(70,24); powerBox.Position=UDim2.new(.5,-35,.5,-12); powerBox.BackgroundTransparency=1; powerBox.Text=tostring(config.Power); powerBox.TextColor3=Color3.fromRGB(255,255,255); powerBox.Font=Enum.Font.GothamBlack; powerBox.TextSize=12; powerBox.ClearTextOnFocus=false; powerBox.ZIndex=6
    local keyButton=Instance.new("TextButton",powerRow)
    keyButton.Size=UDim2.fromOffset(32,21); keyButton.Position=UDim2.new(1,-40,.5,-10); keyButton.BackgroundColor3=Color3.fromRGB(80,215,255); keyButton.BackgroundTransparency=.58; keyButton.Text=config.Keybind; keyButton.TextColor3=Color3.fromRGB(255,255,255); keyButton.Font=Enum.Font.GothamBold; keyButton.TextSize=11; keyButton.AutoButtonColor=false; keyButton.ZIndex=6; corner(keyButton,8)
    local action=glass(UDim2.new(1,-20,0,34),UDim2.fromOffset(10,101)); action.BackgroundTransparency=.78
    local hit=Instance.new("TextButton",action)
    hit.Size=UDim2.fromScale(1,1); hit.BackgroundTransparency=1; hit.TextColor3=Color3.fromRGB(255,255,255); hit.Font=Enum.Font.GothamBlack; hit.TextSize=12; hit.AutoButtonColor=false; hit.ZIndex=6
    local selector=glass(UDim2.fromOffset(62,24),UDim2.fromOffset(176,12)); selector.ZIndex=8; corner(selector,10)
    local function arrow(symbol,x) local button=Instance.new("TextButton",selector); button.Size=UDim2.fromOffset(18,22); button.Position=UDim2.fromOffset(x,1); button.BackgroundTransparency=1; button.Text=symbol; button.TextColor3=Color3.fromRGB(255,255,255); button.Font=Enum.Font.GothamBold; button.TextSize=11; button.ZIndex=9; return button end
    local up=arrow("<",1); local preview=Instance.new("ImageLabel",selector)
    preview.Size=UDim2.fromOffset(20,18); preview.Position=UDim2.fromOffset(21,3); preview.BackgroundTransparency=.2; preview.BorderSizePixel=0; preview.Image=backgrounds[config.BackgroundIndex]; preview.ScaleType=Enum.ScaleType.Crop; preview.ZIndex=9; corner(preview,3)
    local down=arrow(">",43)
    local autoLine=Instance.new("Frame",main); autoLine.Position=UDim2.fromOffset(16,148); autoLine.Size=UDim2.fromOffset(3,17); autoLine.BackgroundColor3=Color3.fromRGB(36,222,241); autoLine.BorderSizePixel=0; autoLine.ZIndex=6; corner(autoLine,3)
    local autoLabel=Instance.new("TextLabel",main); autoLabel.Position=UDim2.fromOffset(25,144); autoLabel.Size=UDim2.fromOffset(110,25); autoLabel.BackgroundTransparency=1; autoLabel.Text="Auto On Steal"; autoLabel.TextColor3=Color3.fromRGB(255,255,255); autoLabel.Font=Enum.Font.GothamBold; autoLabel.TextSize=10; autoLabel.TextXAlignment=Enum.TextXAlignment.Left; autoLabel.ZIndex=6
    local autoToggle=Instance.new("TextButton",main); autoToggle.Position=UDim2.new(1,-45,0,147); autoToggle.Size=UDim2.fromOffset(36,18); autoToggle.BackgroundColor3=Color3.fromRGB(20,72,91); autoToggle.BackgroundTransparency=.5; autoToggle.BorderSizePixel=0; autoToggle.Text=""; autoToggle.AutoButtonColor=false; autoToggle.ZIndex=6; corner(autoToggle,12)
    local autoStroke=Instance.new("UIStroke",autoToggle); autoStroke.Color=Color3.fromRGB(80,215,255); autoStroke.Transparency=.42; autoStroke.Thickness=1
    local autoKnob=Instance.new("Frame",autoToggle); autoKnob.Size=UDim2.fromOffset(14,14); autoKnob.BorderSizePixel=0; autoKnob.ZIndex=7; corner(autoKnob,10)
    local function paintAuto() tween(autoToggle,{BackgroundColor3=config.AutoOnSteal and Color3.fromRGB(52,157,190) or Color3.fromRGB(20,72,91)}); tween(autoKnob,{Position=config.AutoOnSteal and UDim2.new(.5,2,.5,-7) or UDim2.new(0,2,.5,-7),BackgroundColor3=Color3.fromRGB(80,215,255),BackgroundTransparency=config.AutoOnSteal and .15 or .5}) end
    local function paint()
        local enabled=SnowSpeedBypass.enabled==true
        hit.Text=enabled and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"
        tween(action,{BackgroundColor3=enabled and Color3.fromRGB(53,115,91) or Color3.fromRGB(255,255,255),BackgroundTransparency=enabled and .66 or .78})
        if SnowSpeedBypass.refreshPanel then SnowSpeedBypass.refreshPanel() end
    end
    SnowSpeedBypass.refreshGui=paint
    hit.MouseButton1Click:Connect(function() SnowSpeedBypass.setEnabled(not SnowSpeedBypass.enabled); paint() end)
    local autoWasStealing=false
    local function syncAutoOnSteal()
        if not config.AutoOnSteal then autoWasStealing=false; return end
        local stealing=false
        if isStealState then
            local ok,value=pcall(isStealState)
            stealing=ok and value==true
        end
        if stealing==autoWasStealing then return end
        autoWasStealing=stealing
        if SnowSpeedBypass.enabled~=stealing then SnowSpeedBypass.setEnabled(stealing); paint() end
    end
    autoToggle.MouseButton1Click:Connect(function() config.AutoOnSteal=not config.AutoOnSteal; autoWasStealing=false; paintAuto(); syncAutoOnSteal() end)
    local function setBackground(index) config.BackgroundIndex=((index-1)%#backgrounds)+1; bg.Image=backgrounds[config.BackgroundIndex]; preview.Image=backgrounds[config.BackgroundIndex] end
    up.MouseButton1Click:Connect(function() setBackground(config.BackgroundIndex-1) end); down.MouseButton1Click:Connect(function() setBackground(config.BackgroundIndex+1) end)
    powerBox.FocusLost:Connect(function() local n=tonumber(powerBox.Text); config.Power=n and math.clamp(math.floor(n),10000,150000) or 100000; SnowSpeedBypass.power=config.Power; powerBox.Text=tostring(config.Power); if SnowSpeedBypass.enabled then SnowSpeedBypass.setEnabled(false); SnowSpeedBypass.setEnabled(true) end end)
    local listening=false
    keyButton.MouseButton1Click:Connect(function() listening=true; keyButton.Text="..." end)
    UIS.InputBegan:Connect(function(input,processed) if input.UserInputType~=Enum.UserInputType.Keyboard then return end; if listening then if input.KeyCode==Enum.KeyCode.Escape then listening=false; keyButton.Text=config.Keybind elseif input.KeyCode~=Enum.KeyCode.Unknown then config.Keybind=input.KeyCode.Name; keyButton.Text=config.Keybind; listening=false end elseif not processed and input.KeyCode.Name==config.Keybind then SnowSpeedBypass.setEnabled(not SnowSpeedBypass.enabled); paint() end end)
    local dragging,dragStart,startPosition,dragInput=false,nil,nil,nil
    main.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStart=input.Position; startPosition=main.Position; input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
    main.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end end)
    UIS.InputChanged:Connect(function(input) if dragging and input==dragInput then local delta=input.Position-dragStart; main.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y) end end)
    task.spawn(function()
        while gui.Parent do syncAutoOnSteal(); task.wait(.1) end
    end)
    paintAuto(); paint()
end

function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local state=headlessState[char] or {}; headlessState[char]=state
    if enabled then
        if state.headTransparency==nil then
            state.headTransparency=head.Transparency
            state.headCanCollide=head.CanCollide
            local face=head:FindFirstChild("face")
            state.face=face and face:Clone() or nil
        end
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head
    else
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        if state.headTransparency~=nil then
            head.Transparency=state.headTransparency
            head.CanCollide=state.headCanCollide
            if state.face and not head:FindFirstChild("face") then state.face:Clone().Parent=head end
            state.headTransparency=nil; state.headCanCollide=nil; state.face=nil
        end
    end
end

function applyKorbloxToChar(char, mode)
    if not char then return end
    mode = mode == true and "RIGHT" or (mode == false and "OFF" or tostring(mode or "OFF"))
    local legs={
        LEFT={asset="rbxassetid://139607673",target="LeftUpperLeg",hide={"LeftUpperLeg","LeftLowerLeg","LeftFoot"}},
        RIGHT={asset="rbxassetid://139607718",target="RightUpperLeg",hide={"RightUpperLeg","RightLowerLeg","RightFoot"}}
    }
    for side,data in pairs(legs) do
        local old=char:FindFirstChild("SnowKorblox"..side)
        if old then old:Destroy() end
        for _,partName in ipairs(data.hide) do
            local part=char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then part.Transparency=0 end
        end
    end
    if mode=="OFF" then return end
    for side,data in pairs(legs) do
        if mode==side or mode=="BOTH" then
            local target=char:FindFirstChild(data.target)
            if target and target:IsA("BasePart") then
                local ok,objects=pcall(function() return game:GetObjects(data.asset) end)
                local asset=ok and objects and objects[1]
                local mesh=asset and (asset:IsA("BasePart") and asset or asset:FindFirstChildWhichIsA("BasePart",true))
                if mesh then
                    asset.Name="SnowKorblox"..side
                    asset.Parent=char
                    mesh.Anchored=false; mesh.CanCollide=false; mesh.Massless=true
                    mesh.CFrame=target.CFrame
                    local weld=Instance.new("WeldConstraint")
                    weld.Part0=target; weld.Part1=mesh; weld.Parent=mesh
                    for _,partName in ipairs(data.hide) do
                        local part=char:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then part.Transparency=1 end
                    end
                end
            end
        end
    end
end

-- BAT SKINS -----------------------------------------------------------
-- These are client-side cosmetic models welded to the equipped Bat.  The
-- selector exposes NONE, SCYTHE, and SWORD.
function setSnowBatSounds(on)
    batSoundsEnabled=on==true
    for _,conn in ipairs(SnowBatSounds.conns) do pcall(function() conn:Disconnect() end) end
    SnowBatSounds.conns={}
    if SnowBatSounds.custom then pcall(function() SnowBatSounds.custom:Destroy() end); SnowBatSounds.custom=nil end
    if not batSoundsEnabled then return end
    local function hookTool(tool)
        if not tool or not tool:IsA("Tool") or not tool.Name:lower():find("bat") then return end
        local handle=tool:FindFirstChild("Handle"); if not handle then return end
        local custom=Instance.new("Sound"); custom.Name="SnowBatCustomSound"; custom.SoundId="rbxassetid://5713085119"; custom.Volume=1; custom.RollOffMode=Enum.RollOffMode.Inverse; custom.MaxDistance=1000; custom.Parent=handle; SnowBatSounds.custom=custom
        local function hookSound(sound)
            if not sound:IsA("Sound") or sound==custom or sound.Name=="SnowBatCustomSound" then return end
            table.insert(SnowBatSounds.conns,sound:GetPropertyChangedSignal("Playing"):Connect(function()
                if batSoundsEnabled and sound.Playing then pcall(function() sound:Stop(); custom:Stop(); custom.TimePosition=.2; custom:Play() end) end
            end))
        end
        for _,item in ipairs(tool:GetDescendants()) do hookSound(item) end
        table.insert(SnowBatSounds.conns,tool.DescendantAdded:Connect(hookSound))
    end
    local function hookCharacter(char)
        if not char then return end
        for _,tool in ipairs(char:GetChildren()) do hookTool(tool) end
        table.insert(SnowBatSounds.conns,char.ChildAdded:Connect(hookTool))
    end
    hookCharacter(LP.Character)
    table.insert(SnowBatSounds.conns,LP.CharacterAdded:Connect(hookCharacter))
end
function findSnowBat()
    local char=LP.Character
    local backpack=LP:FindFirstChildOfClass("Backpack")
    for _,container in ipairs({char,backpack}) do
        local bat=container and (container:FindFirstChild("Bat") or container:FindFirstChild("bat"))
        if bat and bat:IsA("Tool") then return bat end
    end
    return nil
end

function clearSnowBatSkin(tool)
    if not tool then return end
    -- Remove Snow's cosmetic container plus known foreign cosmetic residue.
    -- This prevents an old weapon model from remaining welded to the Bat.
    for _,name in ipairs({"SnowBatSkin","FlowerSkin_KatanaRealistic","FlowerSkin_AssetKatana"}) do
        local old=tool:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local handle=tool:FindFirstChild("Handle")
    local original=batSkinOriginal[tool]
    if handle and handle:IsA("BasePart") and original then
        handle.Transparency=original.transparency
        handle.LocalTransparencyModifier=original.localTransparency
        handle.CastShadow=original.castShadow
    end
    local slash=tool:FindFirstChild("Slash")
    if slash and slash:IsA("Sound") and original and original.slashSoundId then slash.SoundId=original.slashSoundId end
end

function applySnowSwordColor(visual)
    local color=swordColors[swordColorMode]
    if not visual or not color then return end
    visual.Color=color
    if visual:IsA("UnionOperation") then visual.UsePartColor=true end
    local mesh=visual:FindFirstChildWhichIsA("SpecialMesh")
    if mesh then mesh.VertexColor=Vector3.new(color.R,color.G,color.B) end
end

function refreshSnowSwordColor()
    local tool=findSnowBat()
    local visual=tool and tool:FindFirstChild("SnowBatSkin") and tool.SnowBatSkin:FindFirstChild("SnowSword") and tool.SnowBatSkin.SnowSword:FindFirstChild("SwordVisual")
    applySnowSwordColor(visual)
end

function applySnowBatSkin(mode)
    mode=tostring(mode or "NONE"):upper()
    if mode~="NONE" and mode~="SCYTHE" and mode~="SWORD" then mode="NONE" end
    batSkinMode=mode
    local tool=findSnowBat()
    if not tool then batSkinAppliedTool=nil; batSkinAppliedMode=nil; return false end
    clearSnowBatSkin(tool)
    if mode=="NONE" then batSkinAppliedTool=tool; batSkinAppliedMode=mode; return true end

    local handle=tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end
    if not batSkinOriginal[tool] then
        local slash=tool:FindFirstChild("Slash")
        batSkinOriginal[tool]={transparency=handle.Transparency,localTransparency=handle.LocalTransparencyModifier,castShadow=handle.CastShadow,slashSoundId=slash and slash:IsA("Sound") and slash.SoundId or nil}
    end
    handle.Transparency=1; handle.LocalTransparencyModifier=1; handle.CastShadow=false
    local slash=tool:FindFirstChild("Slash")
    if slash and slash:IsA("Sound") then
        slash.SoundId=(batSoundsEnabled and batSkinSoundIds[mode]) or (batSkinOriginal[tool] and batSkinOriginal[tool].slashSoundId) or slash.SoundId
    end

    local folder=Instance.new("Folder")
    folder.Name="SnowBatSkin"; folder:SetAttribute("SnowBatSkinMode",mode); folder.Parent=tool
    local model=Instance.new("Model")
    model.Name=(mode=="SWORD") and "SnowSword" or "SnowScythe"
    model.Parent=folder

    -- Sword uses the supplied Roblox asset as a local cosmetic welded to Bat.
    if mode=="SWORD" then
        local ok,objects=pcall(function() return game:GetObjects("rbxassetid://18566246244") end)
        local source=ok and objects and objects[1]
        local sourcePart=source and (source:IsA("BasePart") and source or source:FindFirstChildWhichIsA("BasePart",true))
        if not sourcePart then
            folder:Destroy()
            clearSnowBatSkin(tool)
            return false
        end
        local visual=sourcePart:Clone()
        visual.Name="SwordVisual"
        visual.Anchored=false; visual.CanCollide=false; visual.CanTouch=false; visual.CanQuery=false; visual.Massless=true
        -- Some catalog assets use a SpecialMesh: scale that mesh directly,
        -- otherwise scale the MeshPart/BasePart itself.
        local swordMesh=visual:FindFirstChildWhichIsA("SpecialMesh")
        if swordMesh then
            pcall(function() swordMesh.Scale=swordMesh.Scale*1.6 end)
        else
            pcall(function() visual.Size=visual.Size*1.6 end)
        end
        visual.CFrame=handle.CFrame*CFrame.new(-0.02,-0.52,-0.2)*CFrame.Angles(math.rad(45),0,math.rad(5))
        visual.Parent=model
        applySnowSwordColor(visual)
        local weld=Instance.new("WeldConstraint"); weld.Part0=handle; weld.Part1=visual; weld.Parent=visual
        batSkinAppliedTool=tool; batSkinAppliedMode=mode
        return true
    end
    local function addPart(name,size,offset,color,material)
        local part=Instance.new("Part")
        part.Name=name; part.Size=size; part.Color=color; part.Material=material or Enum.Material.Metal
        part.TopSurface=Enum.SurfaceType.Smooth; part.BottomSurface=Enum.SurfaceType.Smooth
        part.Anchored=false; part.CanCollide=false; part.CanTouch=false; part.CanQuery=false; part.Massless=true
        part.CFrame=handle.CFrame*offset; part.Parent=model
        local weld=Instance.new("WeldConstraint"); weld.Part0=handle; weld.Part1=part; weld.Parent=part
        return part
    end
    local black=Color3.fromRGB(18,18,21)
    local red=Color3.fromRGB(210,42,48)
    local gold=Color3.fromRGB(255,190,54)
    addPart("Handle",Vector3.new(.18,3.4,.18),CFrame.new(0,.2,0),black)
    local blade=addPart("Blade",Vector3.new(2.45,.18,.42),CFrame.new(.78,1.56,0)*CFrame.Angles(0,0,math.rad(-25)),red,Enum.Material.Neon)
    addPart("BladeEdge",Vector3.new(1.5,.12,.28),CFrame.new(1.15,1.22,0)*CFrame.Angles(0,0,math.rad(32)),gold,Enum.Material.Neon)
    local fire=Instance.new("ParticleEmitter"); fire.Color=ColorSequence.new(red,gold); fire.Rate=10; fire.Lifetime=NumberRange.new(.2,.4); fire.Speed=NumberRange.new(.2,.6); fire.Size=NumberSequence.new(.08,0); fire.Texture="rbxasset://textures/particles/sparkles_main.dds"; fire.Parent=blade
    batSkinAppliedTool=tool; batSkinAppliedMode=mode
    return true
end

task.spawn(function()
    while task.wait(.15) do
        local tool=findSnowBat()
        local foreignSkin=tool and (tool:FindFirstChild("FlowerSkin_KatanaRealistic") or tool:FindFirstChild("FlowerSkin_AssetKatana"))
        if tool~=batSkinAppliedTool or batSkinAppliedMode~=batSkinMode or foreignSkin then
            pcall(function() applySnowBatSkin(batSkinMode) end)
        end
    end
end)

-- MEDUSA SKINS / SOUNDS ------------------------------------------------
-- Adapted from Ambitious Custom Tools: the original tool stays intact and a
-- local mesh replica is attached to its Handle with the matching Motor6D C0.
local snowMedusaSkins={
    SKULL={mesh="rbxassetid://2050312704",texture="rbxassetid://2050313393",scale=Vector3.new(1,1,1),c0=CFrame.new(0,.65,-.4)*CFrame.Angles(math.rad(330),0,0)},
    GOLDEN_DESERT_EAGLE={mesh="rbxassetid://430251413",texture="rbxassetid://435840335",scale=Vector3.new(.01,.01,.01),c0=CFrame.new(0,0,-.8)*CFrame.Angles(math.rad(330),math.rad(180),0)},
}

function findSnowMedusa()
    local char=LP.Character
    local backpack=LP:FindFirstChildOfClass("Backpack")
    for _,container in ipairs({char,backpack}) do
        if container then
            for _,item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local name=item.Name:lower()
                    if name:find("medusa") or name:find("head") or name:find("stone") then return item end
                end
            end
        end
    end
    return nil
end

function clearSnowMedusaSkin(tool)
    if not tool then return end
    local replica=tool:FindFirstChild("SnowMedusaSkin")
    if replica then replica:Destroy() end
    local original=medusaSkinOriginal[tool]
    if original then
        for instance,state in pairs(original) do
            if instance and instance.Parent then
                pcall(function()
                    if instance:IsA("BasePart") then
                        instance.LocalTransparencyModifier=state.localTransparency
                        instance.CastShadow=state.castShadow
                    elseif instance:IsA("Decal") or instance:IsA("Texture") then
                        instance.Transparency=state.transparency
                    end
                end)
            end
        end
    end
end

function applySnowMedusaSkin(mode)
    mode=tostring(mode or "NONE"):upper()
    if mode~="NONE" and not snowMedusaSkins[mode] then return false end
    medusaSkinMode=mode
    local tool=findSnowMedusa()
    if not tool then medusaSkinAppliedTool=nil; medusaSkinAppliedMode=nil; return false end
    if mode=="NONE" then
        clearSnowMedusaSkin(tool)
        medusaSkinAppliedTool=tool; medusaSkinAppliedMode=mode
        return true
    end
    local skin=snowMedusaSkins[mode]
    local handle=tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end
    clearSnowMedusaSkin(tool)

    if not medusaSkinOriginal[tool] then
        local saved={}
        for _,item in ipairs(tool:GetDescendants()) do
            if item:IsA("BasePart") then
                saved[item]={localTransparency=item.LocalTransparencyModifier,castShadow=item.CastShadow}
            elseif item:IsA("Decal") or item:IsA("Texture") then
                saved[item]={transparency=item.Transparency}
            end
        end
        medusaSkinOriginal[tool]=saved
    end
    -- Hide only the local visual pieces, as Ambitious does, while retaining
    -- the real Tool and its scripts/touch behaviour.
    for item,_ in pairs(medusaSkinOriginal[tool]) do
        pcall(function()
            if item:IsA("BasePart") then item.LocalTransparencyModifier=1; item.CastShadow=false
            elseif item:IsA("Decal") or item:IsA("Texture") then item.Transparency=1 end
        end)
    end

    local folder=Instance.new("Folder")
    folder.Name="SnowMedusaSkin"; folder:SetAttribute("SnowMedusaSkinMode",mode); folder.Parent=tool
    local visual=Instance.new("Part")
    visual.Name="MainPart"; visual.Size=Vector3.new(1,1,1); visual.Transparency=0
    visual.CanCollide=false; visual.CanTouch=false; visual.CanQuery=false; visual.Massless=true; visual.Anchored=false; visual.Parent=folder
    local mesh=Instance.new("SpecialMesh")
    mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=skin.mesh; mesh.TextureId=skin.texture; mesh.Scale=skin.scale; mesh.Parent=visual
    local motor=Instance.new("Motor6D")
    motor.Name="SnowMedusaMotor"; motor.Part0=handle; motor.Part1=visual; motor.C0=skin.c0; motor.Parent=visual
    medusaSkinAppliedTool=tool; medusaSkinAppliedMode=mode
    return true
end

function setSnowMedusaSounds(on)
    medusaSoundsEnabled=on==true
    for _,conn in ipairs(SnowMedusaSounds.conns) do pcall(function() conn:Disconnect() end) end
    SnowMedusaSounds.conns={}
    if SnowMedusaSounds.custom then pcall(function() SnowMedusaSounds.custom:Destroy() end); SnowMedusaSounds.custom=nil end
    if not medusaSoundsEnabled then return end
    local function hookTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        local name=tool.Name:lower()
        if not (name:find("medusa") or name:find("head") or name:find("stone")) then return end
        local handle=tool:FindFirstChild("Handle")
        if not handle then
            task.delay(.2,function() if medusaSoundsEnabled and tool.Parent then hookTool(tool) end end)
            return
        end
        if handle:FindFirstChild("SnowMedusaCustomSound") then return end
        local custom=Instance.new("Sound")
        custom.Name="SnowMedusaCustomSound"; custom.SoundId="rbxassetid://3102797479"; custom.Volume=1; custom.RollOffMode=Enum.RollOffMode.Inverse; custom.MaxDistance=1000; custom.Parent=handle
        SnowMedusaSounds.custom=custom
        local function hookSound(sound)
            if not sound:IsA("Sound") or sound==custom or sound.Name=="SnowMedusaCustomSound" then return end
            table.insert(SnowMedusaSounds.conns,sound:GetPropertyChangedSignal("Playing"):Connect(function()
                if medusaSoundsEnabled and sound.Playing and custom.Parent then
                    pcall(function() sound:Stop(); custom:Stop(); custom:Play() end)
                    -- Ambitious plays the Medusa custom sound twice, with its .5s gap.
                    task.delay(.5,function()
                        if medusaSoundsEnabled and custom.Parent then pcall(function() custom:Stop(); custom:Play() end) end
                    end)
                end
            end))
        end
        for _,item in ipairs(tool:GetDescendants()) do hookSound(item) end
        table.insert(SnowMedusaSounds.conns,tool.DescendantAdded:Connect(hookSound))
    end
    local function hookContainer(container)
        if not container then return end
        for _,tool in ipairs(container:GetChildren()) do hookTool(tool) end
        table.insert(SnowMedusaSounds.conns,container.ChildAdded:Connect(hookTool))
    end
    hookContainer(LP.Character)
    hookContainer(LP:FindFirstChildOfClass("Backpack"))
    table.insert(SnowMedusaSounds.conns,LP.CharacterAdded:Connect(function(char)
        hookContainer(char)
        hookContainer(LP:FindFirstChildOfClass("Backpack"))
    end))
end

task.spawn(function()
    while task.wait(.35) do
        local tool=findSnowMedusa()
        if tool~=medusaSkinAppliedTool or medusaSkinAppliedMode~=medusaSkinMode then
            pcall(function() applySnowMedusaSkin(medusaSkinMode) end)
        end
    end
end)

function applyCharterToChar(char)
    if not char then return end
    applyHeadlessToChar(char, headlessEnabled)
    applyKorbloxToChar(char, korbloxMode)
end
-- Same packs and data format as the M animation changer.  OFF intentionally
-- stays first so the selector starts with the character's original animations.
ANIM_PACK_ORDER={"OFF","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut",'Wicked "Dancing Through Life"',"Werewolf","Superhero","Toy","No Boundaries","NFL","Amazon Unboxed","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon"}
ANIM_PACKS={
    ["Adidas Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
    ["Adidas Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
    ["Adidas Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
    ["Wicked Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
    Elder={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    Zombie={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
    Mage={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Catwalk Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    Astronaut={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
    ['Wicked "Dancing Through Life"']={WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
    Werewolf={WalkAnim=10921342074,RunAnim=10921336997,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
    Superhero={WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
    Toy={WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307241,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
    ["No Boundaries"]={WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
    NFL={WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
    ["Amazon Unboxed"]={WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
    Vampire={WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
    Ninja={Run=656118852,Walk=656121766,Jump=656117878,Fall=656115606,Swim=656119721,SwimIdle=656121397,Climb=656114359,Idle={656117400,656118341,886742569}},
    Robot={Run=616091570,Walk=616095330,Jump=616090535,Fall=616087089,Swim=616092998,SwimIdle=616094091,Climb=616086039,Idle={616088211,616089559,885531463}},
    Levitation={Run=616010382,Walk=616013216,Jump=616008936,Fall=616005863,Swim=616011509,SwimIdle=616012453,Climb=616003713,Idle={616006778,616008087,886862142}},
    Stylish={Run=616140816,Walk=616146177,Jump=616139451,Fall=616134815,Swim=616143378,SwimIdle=616144772,Climb=616133594,Idle={616136790,616138447,886888594}},
    Bubbly={Run=910025107,Walk=910034870,Jump=910016857,Fall=910001910,Swim=910028158,SwimIdle=910030921,Climb=909997997,Idle={910004836,910009958,1018536639}},
    Cartoon={Run=742638842,Walk=742640026,Jump=742637942,Fall=742637151,Swim=742639220,SwimIdle=742639812,Climb=742636889,Idle={742637544,742638445,885477856}},
}
_animOriginalIds={}
mobBtnTransparencyEnabled=false
perButtonDragEnabled=true
brainrotDetected=false
activeBatBillboard=nil
activeMedusaBillboard=nil
ragdollGuiEnabled=true
persistentRagdollGui=nil
uiLocked=false
infJumpMode="manual"
holdInfJumpConn=nil
manualInfJumpConn=nil
DROP_ASCEND_DURATION=0.2
DROP_ASCEND_SPEED=150
dropBrainrotMode="JUMP"
_GuiKeys = nil

-- ============================================================
-- CYBER EXTRAS
-- ============================================================
espEnabled = false
ESP = {folder=nil, conns={}, labels={}}
enemySpeedEnabled = false
espBoxEnabled = false
espLineEnabled = false
EnemySpeedESP = {conns={}, labels={}}
SnowExtraESP = {boxData={}, lineData={}, conn=nil}
backgroundEnabled = true
backgroundIndex = 1
customGuiBackgroundUrl = ""
bgImageRef = nil
titleIndex = 1
TITLE_IMAGE_ASSETS = {
    "rbxassetid://77790957712601",
    "rbxassetid://133718489512114",
    "rbxassetid://95534041141382",
    "rbxassetid://117631170275532",
    "rbxassetid://128049285673648",
    "rbxassetid://110171624353006",
}

BG_IMAGE_URLS = {
    { url = "rbxassetid://96776094544702", file = "snow_bg_main.png" },
    { url = "rbxassetid://114506514019976", file = "snow_bg_2.png" },
    { url = "rbxassetid://88728512259690", file = "snow_bg_3.png" },
    { url = "rbxassetid://107543939007757", file = "snow_bg_4.png" },
    { url = "rbxassetid://72709609322075", file = "snow_bg_5.png" },
    { url = "rbxassetid://108942792386909", file = "snow_bg_6.png" },
    { url = "rbxassetid://130404437546642", file = "snow_bg_7.png" },
    { url = "rbxassetid://134600633162535", file = "snow_bg_9.png" },
    { url = "rbxassetid://127046807487976", file = "snow_bg_10.png" },
    { url = "rbxassetid://114963693136840", file = "snow_bg_11.png" },
    { url = "rbxassetid://120552239826430", file = "snow_bg_12.png" },
    { url = "rbxassetid://114179714659194", file = "snow_bg_13.png" },
    { url = "rbxassetid://112624364676961", file = "snow_bg_15.png" },
    { url = "rbxassetid://78111423784388", file = "snow_bg_17.png" },
    { url = "rbxassetid://87934298516221", file = "snow_bg_18.png" },
    { url = "rbxassetid://124477262661257", file = "snow_bg_19.png" },
    { url = "rbxassetid://140469084862771", file = "snow_bg_21.png" },
    { url = "rbxassetid://97029378786193", file = "snow_bg_23.png" },
    { url = "rbxassetid://129314299216056", file = "snow_bg_24.png" },
    { url = "rbxassetid://86291544311121", file = "snow_bg_25.png" },
    { url = "rbxassetid://136984463369486", file = "snow_bg_26.png" },
    { url = "rbxassetid://84294939692715", file = "snow_bg_27.png" },
    { url = "rbxassetid://89646139430969", file = "snow_bg_28.png" },
    { url = "rbxassetid://140395511116577", file = "snow_bg_29.png" },
}
-- Each working color owns its own background collection. The inactive color
-- squares are intentionally display-only until their collections are added.
SnowThemeBackgrounds={
    AZZURRO=BG_IMAGE_URLS,
    BIANCO={
        {url="rbxassetid://91028225366233",file="snow_white_bg_1.png"},
        {url="rbxassetid://96109103007752",file="snow_white_bg_2.png"},
        {url="rbxassetid://102923586347024",file="snow_white_bg_3.png"},
        {url="rbxassetid://116460339605490",file="snow_white_bg_4.png"},
        {url="rbxassetid://85270977031941",file="snow_theme_bg_1.png"},
        {url="rbxassetid://139949619812253",file="snow_theme_bg_2.png"},
        {url="rbxassetid://130333049790217",file="snow_theme_bg_3.png"},
        {url="rbxassetid://72801914888817",file="snow_theme_bg_4.png"},
        {url="rbxassetid://98896327506286",file="snow_theme_bg_5.png"},
        {url="rbxassetid://128194736606090",file="snow_theme_bg_6.png"},
        {url="rbxassetid://135588172127075",file="snow_theme_bg_7.png"},
        {url="rbxassetid://119428669345144",file="snow_theme_bg_8.png"},
        {url="rbxassetid://82918811831010",file="snow_theme_bg_9.png"},
        {url="rbxassetid://79010296381398",file="snow_theme_bg_10.png"},
        {url="rbxassetid://75302623319287",file="snow_theme_bg_11.png"},
        {url="rbxassetid://111488941526604",file="snow_theme_bg_12.png"},
    },
}
-- These are intentionally separate from the original AZZURRO collection.
-- Each non-white theme uses this same curated set, tinted to its selected color.
SnowColorThemeBackgrounds={
    {url="rbxassetid://91028225366233",file="snow_white_bg_1.png"}, {url="rbxassetid://96109103007752",file="snow_white_bg_2.png"},
    {url="rbxassetid://102923586347024",file="snow_white_bg_3.png"}, {url="rbxassetid://116460339605490",file="snow_white_bg_4.png"},
    {url="rbxassetid://85270977031941",file="snow_theme_bg_1.png"}, {url="rbxassetid://139949619812253",file="snow_theme_bg_2.png"},
    {url="rbxassetid://130333049790217",file="snow_theme_bg_3.png"}, {url="rbxassetid://72801914888817",file="snow_theme_bg_4.png"},
    {url="rbxassetid://98896327506286",file="snow_theme_bg_5.png"}, {url="rbxassetid://128194736606090",file="snow_theme_bg_6.png"},
    {url="rbxassetid://135588172127075",file="snow_theme_bg_7.png"}, {url="rbxassetid://119428669345144",file="snow_theme_bg_8.png"},
    {url="rbxassetid://82918811831010",file="snow_theme_bg_9.png"}, {url="rbxassetid://79010296381398",file="snow_theme_bg_10.png"},
    {url="rbxassetid://75302623319287",file="snow_theme_bg_11.png"}, {url="rbxassetid://111488941526604",file="snow_theme_bg_12.png"},
}
-- The GUI uses only these three Dragon wallpapers in every theme.
local DragonBackgrounds={
    {url="rbxassetid://107075935121347",file="dragon_background_1.png"},
    {url="rbxassetid://97155328433050",file="dragon_background_2.png"},
}
BG_IMAGE_URLS=DragonBackgrounds
SnowThemeBackgrounds={AZZURRO=DragonBackgrounds,BIANCO=DragonBackgrounds}
SnowColorThemeBackgrounds=DragonBackgrounds
SnowThemeBackgroundIndex={AZZURRO=1,BIANCO=1}
-- The chosen wallpaper follows the player across theme changes.  Theme lists
-- can differ, so this stores the actual asset URL as well as each list index.
snowLastBackgroundUrl=snowLastBackgroundUrl or nil
WHITE_TITLE_ASSET="rbxassetid://135344347165799"
bgLoadedAssets = {}

function resolveBgAsset(fileName)
    local assetFuncs = { getcustomasset, getsynasset, getasset }
    for _, func in ipairs(assetFuncs) do
        if typeof(func) == "function" then
            local ok, a = pcall(function() return func(fileName) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
    end
    if typeof(getcustomasset) == "function" then
        local ok, a = pcall(function() return getcustomasset(fileName, true) end)
        if ok and type(a) == "string" and a ~= "" then return a end
    end
    return ""
end

function downloadBgImage(entry)
    -- Roblox assets are already valid GUI image sources; do not try to download them as HTTP files.
    if entry and type(entry.url)=="string" and (entry.url:match("^rbxassetid://") or entry.url:match("^rbxthumb://")) then
        return entry.url
    end
    if isfile and isfile(entry.file) then
        local a = resolveBgAsset(entry.file)
        if a ~= "" then return a end
    end
    local raw = nil
    local ok, result = pcall(function() return game:HttpGet(entry.url) end)
    if ok and result and #result > 100 then raw = result end
    if not raw then
        local reqFunc = (http and http.request) or request or (syn and syn.request)
        if reqFunc then
            local res = reqFunc({ Url = entry.url, Method = "GET" })
            if res and res.Body and #res.Body > 100 then raw = res.Body end
        end
    end
    if not raw then return "" end
    pcall(function() writefile(entry.file, raw) end)
    task.wait(0.05)
    return resolveBgAsset(entry.file)
end

task.spawn(function()
    local collection=BG_IMAGE_URLS
    for i, entry in ipairs(collection) do
        local asset = downloadBgImage(entry)
        if BG_IMAGE_URLS==collection then bgLoadedAssets[i] = (asset ~= "" and asset) or entry.url end
    end
end)

function applyBackgroundImage(index,preserveLast)
    backgroundIndex = index or 0
    if SnowThemeBackgroundIndex and snowUiThemeName then SnowThemeBackgroundIndex[snowUiThemeName]=backgroundIndex end
    if not bgImageRef then return end
    if backgroundIndex == -1 and customGuiBackgroundUrl ~= "" then
        bgImageRef.Image=customGuiBackgroundUrl
        bgImageRef.Visible=true
        backgroundEnabled=true
        snowLastBackgroundUrl=customGuiBackgroundUrl
        return
    end
    if backgroundIndex == 0 then
        bgImageRef.Image = ""
        bgImageRef.Visible = false
        backgroundEnabled = false
        return
    end
    local asset = bgLoadedAssets[backgroundIndex]
    local entry = BG_IMAGE_URLS[backgroundIndex]
    -- If the current collection does not include the last selected wallpaper,
    -- retain that picture instead of silently switching to a different one.
    if preserveLast and snowLastBackgroundUrl then
        local matchingIndex=nil
        for i,candidate in ipairs(BG_IMAGE_URLS) do
            if candidate.url==snowLastBackgroundUrl then matchingIndex=i; break end
        end
        if matchingIndex then
            backgroundIndex=matchingIndex
            if SnowThemeBackgroundIndex and snowUiThemeName then SnowThemeBackgroundIndex[snowUiThemeName]=matchingIndex end
            asset=bgLoadedAssets[matchingIndex]; entry=BG_IMAGE_URLS[matchingIndex]
        else
            bgImageRef.Image=snowLastBackgroundUrl; bgImageRef.Visible=true; backgroundEnabled=true
            return
        end
    end
    if (not asset or asset == "") and entry then
        asset = downloadBgImage(entry)
        if asset == "" then asset = entry.url end
        bgLoadedAssets[backgroundIndex] = asset
    end
    if asset and asset ~= "" then
        bgImageRef.Image = asset
        bgImageRef.Visible = true
        backgroundEnabled = true
        snowLastBackgroundUrl=entry and entry.url or asset
    end
end

SnowBaseUi=nil
function SnowCaptureBaseUi()
    if SnowBaseUi or not (GuiRefs and GuiRefs.hub) then return end
    SnowBaseUi={}
    for _,item in ipairs(GuiRefs.hub:GetDescendants()) do
        local state={}
        if item:IsA("GuiObject") then state.BackgroundColor3=item.BackgroundColor3; state.TextColor3=(item:IsA("TextLabel") or item:IsA("TextButton")) and item.TextColor3 or nil end
        if item:IsA("ImageLabel") or item:IsA("ImageButton") then state.ImageColor3=item.ImageColor3 end
        if item:IsA("UIStroke") then state.Color=item.Color; state.Transparency=item.Transparency; state.Thickness=item.Thickness end
        if next(state) then SnowBaseUi[item]=state end
    end
end
function SnowRestoreBaseUi()
    if not SnowBaseUi then return end
    for item,state in pairs(SnowBaseUi) do
        if item and item.Parent then
            if state.BackgroundColor3 then item.BackgroundColor3=state.BackgroundColor3 end
            if state.TextColor3 then item.TextColor3=state.TextColor3 end
            if state.ImageColor3 then item.ImageColor3=state.ImageColor3 end
            if state.Color then item.Color=state.Color; item.Transparency=state.Transparency; item.Thickness=state.Thickness end
        end
    end
end

function SnowApplyUiTheme(name,rebuildMobile)
    name="BIANCO"
    local previousTheme=snowUiThemeName
    if SnowThemeBackgroundIndex and previousTheme then SnowThemeBackgroundIndex[previousTheme]=backgroundIndex end
    snowUiThemeName=(name=="BIANCO") and "BIANCO" or "AZZURRO"
    BG_IMAGE_URLS=SnowThemeBackgrounds[snowUiThemeName]
    bgLoadedAssets={}
    backgroundIndex=math.clamp(math.floor((SnowThemeBackgroundIndex and SnowThemeBackgroundIndex[snowUiThemeName]) or 1),1,#BG_IMAGE_URLS)
    local tint=SnowGetUiThemeColor()
    SnowRestoreBaseUi()
    -- Do not tint photos: each theme has its own original image collection.
    if bgImageRef then bgImageRef.ImageColor3=(snowUiThemeName=="AZZURRO") and SnowGetUiThemeColor() or Color3.fromRGB(255,255,255) end
    if GuiRefs then
        local titleAsset=(snowUiThemeName=="BIANCO") and WHITE_TITLE_ASSET or TITLE_IMAGE_ASSETS[math.clamp(tonumber(titleIndex) or 1,1,#TITLE_IMAGE_ASSETS)]
        for _,refName in ipairs({"snowTitle","reopenTitle"}) do
            local ref=GuiRefs[refName]
            if ref and (ref:IsA("ImageLabel") or ref:IsA("ImageButton")) then ref.Image=titleAsset; ref.ImageColor3=Color3.fromRGB(255,255,255) end
        end
        local content=GuiRefs.contentFrame
        if content then
            for _,item in ipairs(content:GetDescendants()) do
                if item.Name=="SelectedTitlePreview" and (item:IsA("ImageLabel") or item:IsA("ImageButton")) then item.ImageColor3=Color3.fromRGB(255,255,255) end
                if item.Name=="TitleSelector" then item.Visible=(snowUiThemeName=="AZZURRO") end
            end
        end
    end
    -- Existing Dragon billboards update immediately; new ones use the same
    -- color when they are created below.
    for _,item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BillboardGui") and (item.Name:find("Dragon") or item.Name=="SnowEnemySpeed") then
            for _,child in ipairs(item:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then child.TextColor3=tint end
                if child:IsA("UIStroke") then child.Color=tint end
                if child:IsA("ImageLabel") and child.Name=="DragonLogo" then child.ImageColor3=tint end
            end
        end
    end
    if snowUiThemeName=="BIANCO" then
        for _,item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Highlight") and (item.Name:find("DragonESP") or item.Name=="DragonChams") then
                item.FillColor=Color3.fromRGB(255,255,255); item.OutlineColor=Color3.fromRGB(255,255,255)
            elseif item:IsA("BillboardGui") and (item.Name:find("DragonESP") or item.Name=="SnowEnemySpeed") then
                for _,label in ipairs(item:GetDescendants()) do if label:IsA("TextLabel") then label.TextColor3=Color3.fromRGB(255,255,255) end end
            end
        end
    else
        for _,item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Highlight") and (item.Name:find("DragonESP") or item.Name=="DragonChams") then
                item.FillColor=Color3.fromRGB(12,65,84); item.OutlineColor=tint
            end
        end
        for _,box in pairs(SnowExtraESP and SnowExtraESP.boxData or {}) do pcall(function() box.Color=tint end) end
        for _,line in pairs(SnowExtraESP and SnowExtraESP.lineData or {}) do pcall(function() line.Color=tint end) end
    end
    if stealBarFrame then
        local fill=stealBarFrame:FindFirstChild("FillLine",true)
        if fill and fill:IsA("Frame") then
            -- The Dragon bar always fills in snow white; changing GUI colour must
            -- never turn the fill back green or blue.
            fill.BackgroundColor3=Color3.fromRGB(255,255,255)
            local gradient=fill:FindFirstChildOfClass("UIGradient")
            if gradient then
                gradient.Color=ColorSequence.new(Color3.fromRGB(238,243,247),Color3.fromRGB(255,255,255))
            end
        end
    end
    snowThemeName=(snowUiThemeName=="BIANCO") and "WHITE" or "AZZURRO"
    -- Rebuild from fixed base colors; never blend a previous theme into the
    -- next one. That prevents leftover cyan and the unwanted bright outline.
    if snowUiThemeName=="AZZURRO" then
        C.blue=Color3.fromRGB(145,220,255); C.blueDim=Color3.fromRGB(82,170,205); C.blueDark=Color3.fromRGB(12,45,62)
        C.divider=Color3.fromRGB(48,120,150); C.textDim=Color3.fromRGB(180,225,240); C.textMuted=Color3.fromRGB(120,180,205); C.white=Color3.fromRGB(145,220,255)
    else
        C.blue=tint; C.blueDim=_snowBlend(tint,Color3.fromRGB(40,40,40),0.55); C.blueDark=_snowBlend(Color3.fromRGB(3,3,3),tint,0.12)
        C.divider=_snowBlend(Color3.fromRGB(32,32,32),tint,0.25); C.textDim=_snowBlend(Color3.fromRGB(160,160,160),tint,0.25); C.textMuted=_snowBlend(Color3.fromRGB(100,100,100),tint,0.20); C.white=Color3.fromRGB(255,255,255)
    end
    if snowUiThemeName=="BIANCO" and GuiRefs and GuiRefs.hub then
        for _,item in ipairs(GuiRefs.hub:GetDescendants()) do
            if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then item.TextColor3=Color3.fromRGB(255,255,255) end
            if item:IsA("UIStroke") then item.Color=Color3.fromRGB(255,255,255) end
            if item:IsA("ScrollingFrame") then item.ScrollBarImageColor3=Color3.fromRGB(255,255,255) end
            if item:IsA("GuiObject") then
                local c=item.BackgroundColor3
                if item:IsA("Frame") and item.Name:sub(1,6)~="Theme_" and item:FindFirstChildOfClass("UIStroke") then
                    item.BackgroundColor3=Color3.fromRGB(0,0,0)
                    item.BackgroundTransparency=.38
                end
                if item:IsA("Frame") and item.Size.X.Offset==18 and item.Size.Y.Offset==18 then
                    item.BackgroundColor3=Color3.fromRGB(255,255,255)
                elseif item.Name:sub(1,6)~="Theme_" and c and c.B>c.R*1.12 and c.G>c.R*1.08 then
                    item.BackgroundColor3=Color3.fromRGB(26,26,30)
                end
            end
        end
    end
    if GuiRefs and GuiRefs.inner then
        local innerStroke=GuiRefs.inner:FindFirstChildOfClass("UIStroke")
        if innerStroke then innerStroke.Color=Color3.fromRGB(45,45,45) end
    end
    if snowUiThemeName=="BIANCO" and GuiRefs and GuiRefs.contentFrame then
        for _,row in ipairs(GuiRefs.contentFrame:GetDescendants()) do
            if row:IsA("UIStroke") and row.Parent and row.Parent.Name~="Theme_AZZURRO" and row.Parent.Name~="Theme_BIANCO" and row.Parent.Name~="Theme_BLU" and row.Parent.Name~="Theme_VIOLA" and row.Parent.Name~="Theme_ROSA" then
                row.Color=C.divider
            end
            -- One shared row recipe, based on Anti Ragdoll: black transparent
            -- surface, a thin divider, and the same compact switch everywhere.
            if row:IsA("Frame") and row.Name:sub(1,6)~="Theme_" then
                local rowStroke=row:FindFirstChildOfClass("UIStroke")
                if rowStroke then
                    row.BackgroundColor3=Color3.fromRGB(0,0,0)
                    row.BackgroundTransparency=.38
                    rowStroke.Color=(snowUiThemeName=="BIANCO") and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,130,150)
                    rowStroke.Transparency=.58
                    rowStroke.Thickness=1
                end
                if row.Size.X.Offset==42 and row.Size.Y.Offset==22 then
                    local knob=row:FindFirstChildOfClass("Frame")
                    local isOn=knob and knob.Position.X.Scale>0.5
                    row.BackgroundColor3=isOn and C.blueDim or C.blueDark
                    row.BackgroundTransparency=.5
                    local trackStroke=row:FindFirstChildOfClass("UIStroke")
                    if trackStroke then trackStroke.Color=(snowUiThemeName=="BIANCO") and Color3.fromRGB(255,255,255) or C.blueDim end
                    if knob then knob.BackgroundColor3=tint; knob.BackgroundTransparency=isOn and .15 or .5 end
                end
            end
            local active=row:FindFirstChild("ActiveLine")
            if active and active:IsA("Frame") then
                row.BackgroundColor3=_snowBlend(Color3.fromRGB(0,0,0),tint,0.18)
                active.BackgroundColor3=tint
                local rowStroke=row:FindFirstChildOfClass("UIStroke")
                if rowStroke then rowStroke.Color=(snowUiThemeName=="BIANCO") and Color3.fromRGB(255,255,255) or C.divider end
                for _,child in ipairs(row:GetChildren()) do
                    if child:IsA("Frame") and child.Size.X.Offset==42 and child.Size.Y.Offset==22 then
                        local knob=child:FindFirstChildOfClass("Frame")
                        local isOn=knob and knob.Position.X.Scale>0.5
                        child.BackgroundColor3=isOn and C.blueDim or C.blueDark
                        local trackStroke=child:FindFirstChildOfClass("UIStroke")
                        if trackStroke then trackStroke.Color=(snowUiThemeName=="BIANCO") and Color3.fromRGB(255,255,255) or C.blueDim end
                        if knob then knob.BackgroundColor3=tint end
                    end
                end
            end
        end
    end
    -- Only top-level settings rows are normalized here, matching the exact
    -- Anti Ragdoll row recipe without touching their nested controls.
    if snowUiThemeName=="BIANCO" and CategoryRefs and CategoryRefs.contents then
        for _,page in pairs(CategoryRefs.contents) do
            for _,row in ipairs(page:GetChildren()) do
                if row:IsA("Frame") and row.Name~="ThemeSwatches" then
                    if row.Size.Y.Offset==26 then
                        row.BackgroundTransparency=1
                    else
                        row.BackgroundColor3=Color3.fromRGB(0,0,0)
                        row.BackgroundTransparency=.38
                    end
                    local stroke=row:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color=(snowUiThemeName=="BIANCO") and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,130,150)
                        stroke.Transparency=.58
                        stroke.Thickness=1
                    end
                end
            end
        end
    end
    if snowUiThemeName=="BIANCO" and GuiRefs and GuiRefs.tabSeparator then GuiRefs.tabSeparator.BackgroundColor3=Color3.fromRGB(255,255,255) end
    if snowUiThemeName=="BIANCO" and GuiRefs and GuiRefs.categoryList then
        for _,tab in ipairs(GuiRefs.categoryList:GetChildren()) do
            if tab:IsA("TextButton") then tab.TextColor3=Color3.fromRGB(255,255,255) end
            local label=tab:FindFirstChild("TabLabel")
            if label and label:IsA("TextLabel") then label.TextColor3=Color3.fromRGB(255,255,255) end
        end
    end
    applyBackgroundImage(backgroundIndex)
    if SnowRefreshHitCircleTheme then SnowRefreshHitCircleTheme() end
    if SnowRefreshBackgroundCarousel then SnowRefreshBackgroundCarousel() end
    if SnowRefreshBackgroundListVisual then SnowRefreshBackgroundListVisual() end
    if snowUiThemeName=="AZZURRO" and GuiRefs and GuiRefs.contentFrame then
        -- Azure owns its native card/tab styling; it never inherits white
        -- strokes left by the other theme.
        for _,item in ipairs(GuiRefs.contentFrame:GetDescendants()) do
            local index=tonumber(item.Name:match("^BackgroundCard_(%d+)$"))
            if index and item:IsA("ImageButton") then
                local stroke=item:FindFirstChildOfClass("UIStroke")
                if stroke then
                    local chosen=index==backgroundIndex
                    stroke.Color=chosen and Color3.fromRGB(80,215,255) or Color3.fromRGB(70,70,78)
                    stroke.Transparency=chosen and 0 or .55
                    stroke.Thickness=chosen and 1.8 or 1
                end
            end
        end
        if GuiRefs.categoryList then
            for _,tab in ipairs(GuiRefs.categoryList:GetChildren()) do
                if tab:IsA("TextButton") then
                    local selected=(CategoryRefs and CategoryRefs.active==tab.Name)
                    tab.BackgroundColor3=Color3.fromRGB(0,0,0)
                    tab.BackgroundTransparency=.38
                    tab.TextColor3=Color3.fromRGB(255,255,255)
                    local label=tab:FindFirstChild("TabLabel")
                    if label and label:IsA("TextLabel") then label.TextColor3=Color3.fromRGB(255,255,255) end
                    local stroke=tab:FindFirstChild("TabStroke")
                    if stroke then stroke.Color=selected and Color3.fromRGB(238,238,242) or Color3.fromRGB(80,82,91); stroke.Transparency=0; stroke.Thickness=1 end
                    local border=tab:FindFirstChild("TabBorder")
                    local outline=border and border:FindFirstChild("SelectionStroke")
                    if outline then outline.Color=Color3.fromRGB(80,215,255); outline.Transparency=selected and 0 or 1 end
                end
            end
        end
        if CategoryRefs and CategoryRefs.contents then
            for _,page in pairs(CategoryRefs.contents) do
                for _,row in ipairs(page:GetChildren()) do
                    if row:IsA("Frame") and row.Name~="ThemeSwatches" then
                        if row.Size.Y.Offset==26 then
                            row.BackgroundTransparency=1
                        else
                            row.BackgroundColor3=Color3.fromRGB(0,0,0)
                            row.BackgroundTransparency=.38
                        end
                    end
                end
            end
        end
    end
    if snowUiThemeName=="AZZURRO" and CategoryRefs and CategoryRefs.btnsSide then
        -- Win over any pending tab tween from immediately before the switch.
        task.delay(.35,function()
            if snowUiThemeName~="AZZURRO" then return end
            for _,tab in pairs(CategoryRefs.btnsSide) do
                if tab and tab.Parent then
                    tab.BackgroundColor3=Color3.fromRGB(0,0,0)
                    tab.BackgroundTransparency=.38
                    local label=tab:FindFirstChild("TabLabel")
                    if label and label:IsA("TextLabel") then label.TextColor3=Color3.fromRGB(255,255,255) end
                end
            end
        end)
    end
    if SnowApplyAzureTabs then SnowApplyAzureTabs() end
    if SnowApplyWhiteTabs then SnowApplyWhiteTabs() end
    if SnowHideUiBorders then SnowHideUiBorders() end
    if SnowWakeUi then SnowWakeUi() end
    -- The active button palette is captured while mobile buttons are built.
    if rebuildMobile and mobileButtonsEnabled and buildMobileButtons then buildMobileButtons() end
end

-- ============================================================
-- ESP — Speed Counter + Avatars + Line + Chams (Highlight)
-- ============================================================
function espClear()
    for _,c in pairs(ESP.conns) do pcall(function() c:Disconnect() end) end
    ESP.conns = {}
    for _,data in pairs(ESP.labels) do
        pcall(function() if data.billboard then data.billboard:Destroy() end end)
        pcall(function() if data.highlight then data.highlight:Destroy() end end)
        pcall(function() if data.line then data.line:Destroy() end end)
    end
    ESP.labels = {}
    if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder=nil end
end

function espRemovePlayer(plr)
    if not ESP.labels[plr] then return end
    pcall(function() if ESP.labels[plr].billboard then ESP.labels[plr].billboard:Destroy() end end)
    pcall(function() if ESP.labels[plr].highlight then ESP.labels[plr].highlight:Destroy() end end)
    pcall(function() if ESP.labels[plr].line then ESP.labels[plr].line:Destroy() end end)
    ESP.labels[plr] = nil
end

-- This is deliberately separate from Speed ESP: the Dragon overhead counter is
-- always present on the local player, whether ESP is enabled or not.
snowOverheadGui = nil
snowOverheadSpeedLabel = nil
snowOverheadConn = nil

function createDragonOverhead(char)
    if snowOverheadConn then pcall(function() snowOverheadConn:Disconnect() end) end
    if snowOverheadGui then pcall(function() snowOverheadGui:Destroy() end) end
    snowOverheadConn = nil
    snowOverheadGui = nil
    snowOverheadSpeedLabel = nil

    local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
    if not head then return end
    local billboardColor=Color3.fromRGB(255,255,255)

    local bb = Instance.new("BillboardGui")
    bb.Name = "DragonOverheadInfo"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 280, 0, 104)
    bb.StudsOffset = Vector3.new(0, 1.75, 0)
    bb.MaxDistance = 2000
    bb.LightInfluence = 0
    bb.Parent = head

    local countdownLbl = Instance.new("TextLabel")
    countdownLbl.Name = "RagdollCountdown"
    countdownLbl.Size = UDim2.new(1, 0, 0, 38)
    countdownLbl.Position = UDim2.new(0, 0, 0, -14)
    countdownLbl.BackgroundTransparency = 1
    countdownLbl.Visible = false
    countdownLbl.TextColor3 = billboardColor
    countdownLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    countdownLbl.TextStrokeTransparency = 0
    countdownLbl.Font = Enum.Font.GothamBlack
    countdownLbl.TextSize = 38
    countdownLbl.TextXAlignment = Enum.TextXAlignment.Center
    countdownLbl.ZIndex = 10
    countdownLbl.Parent = bb

    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "Discord"
    discordLbl.Size = UDim2.new(1, 0, 0, 30)
    discordLbl.Position = UDim2.new(0, 0, 0, 26)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/dragonhub"
    discordLbl.Font = Enum.Font.GothamBlack
    discordLbl.TextSize = 21
    discordLbl.TextColor3 = billboardColor
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.TextStrokeTransparency = 0
    discordLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLbl.ZIndex = 10
    discordLbl.Parent = bb

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "SpeedLabel"
    speedLbl.Size = UDim2.new(1, 0, 0, 26)
    speedLbl.Position = UDim2.new(0, 0, 0, 54)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 19
    speedLbl.TextColor3 = billboardColor
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.ZIndex = 10
    speedLbl.Parent = bb

    snowOverheadGui = bb
    snowOverheadSpeedLabel = speedLbl
    snowOverheadConn = RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("overheadSpeed",0.10) then return end
        if not bb.Parent or not char.Parent then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then speedLbl.Text = "Speed: 0" return end
        local v = hrp.AssemblyLinearVelocity
        local spd = math.sqrt(v.X * v.X + v.Z * v.Z)
        -- K7 V2 steers toward the selected speed progressively; show the
        -- selected Aimbot value in Snow's overhead display while it is active.
        if autoBatEnabled and aimbotMode=="AIMBOT" and aimbotNormalVersion=="V2" then
            spd=math.clamp(tonumber(AIMBOT_SPEED) or spd,1,200)
        end
        speedLbl.Text = string.format("Speed: %d", math.floor(spd + 0.5))
    end)
end

snowRagdollCountdownId=0
function showSnowRagdollCountdown()
    if not ragdollGuiEnabled then return end
    local bb=snowOverheadGui
    if not bb or not bb.Parent then
        local char=LP.Character
        if char then createDragonOverhead(char); bb=snowOverheadGui end
    end
    local label=bb and bb:FindFirstChild("RagdollCountdown")
    if not label then return end
    snowRagdollCountdownId=snowRagdollCountdownId+1
    local countdownId=snowRagdollCountdownId
    task.spawn(function()
        for number=3,1,-1 do
            if countdownId~=snowRagdollCountdownId or not label.Parent then return end
            label.Text=tostring(number); label.Visible=true
            task.wait(0.65)
        end
        if countdownId~=snowRagdollCountdownId or not label.Parent then return end
        label.Text="READY!!!"; label.Visible=true
        task.wait(2)
        if countdownId==snowRagdollCountdownId and label.Parent then label.Visible=false end
    end)
end

-- K7's Enemy Ragdoll Timer, rendered with Snow's compact overhead numbers.
Dragon.enemyRagdollTimerConns=Dragon.enemyRagdollTimerConns or {}
function Dragon.stopEnemyRagdollTimer()
    for _,connection in ipairs(Dragon.enemyRagdollTimerConns) do pcall(function() connection:Disconnect() end) end
    Dragon.enemyRagdollTimerConns={}
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player.Character
        local head=char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        local gui=head and head:FindFirstChild("SnowEnemyRagdollTimer")
        if gui then gui:Destroy() end
    end
end
function Dragon.startEnemyRagdollTimer()
    Dragon.stopEnemyRagdollTimer()
    if not Dragon.enemyRagdollTimerEnabled then return end
    local active={}
    local completed={}
    local function clear(player)
        local data=active[player]
        if data and data.gui then pcall(function() data.gui:Destroy() end) end
        active[player]=nil
        completed[player]=nil
    end
    local function getTimer(player)
        local char=player.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health<=0 then return false,nil,char end
        local state=hum:GetState()
        local endTime=player:GetAttribute("RagdollEndTime") or char:GetAttribute("RagdollEndTime") or hum:GetAttribute("RagdollEndTime")
        if type(endTime)=="number" and endTime>workspace:GetServerTimeNow() then return true,endTime-workspace:GetServerTimeNow(),char end
        local down=hum.PlatformStand or state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or char:GetAttribute("Ragdolled")==true or char:GetAttribute("Ragdoll")==true
        return down,nil,char
    end
    table.insert(Dragon.enemyRagdollTimerConns,RunService.Heartbeat:Connect(function()
        if not Dragon.enemyRagdollTimerEnabled then Dragon.stopEnemyRagdollTimer(); return end
        for _,player in ipairs(Players:GetPlayers()) do
            if player~=LP then
                local down,remaining,char=getTimer(player)
                if down and char and remaining and not completed[player] then
                    local head=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    -- Do not show a generic "ready" state: this alert starts
                    -- only when the game supplies a real ragdoll end time.
                    if head then
                        local data=active[player]
                        if not data or not data.gui or data.gui.Adornee~=head then
                            clear(player)
                            local gui=Instance.new("BillboardGui"); gui.Name="SnowEnemyRagdollTimer"; gui.Adornee=head; gui.Size=UDim2.new(0,150,0,42); gui.StudsOffset=Vector3.new(0,5.0,0); gui.AlwaysOnTop=true; gui.MaxDistance=2000; gui.LightInfluence=0; gui.Parent=head
                            local label=Instance.new("TextLabel",gui); label.Size=UDim2.fromScale(1,1); label.BackgroundTransparency=1; label.Font=Enum.Font.GothamBlack; label.TextSize=30; label.TextColor3=SnowGetUiThemeColor(); label.TextStrokeColor3=Color3.fromRGB(0,0,0); label.TextStrokeTransparency=0
                            data={gui=gui,label=label}; active[player]=data
                        end
                        data.label.TextColor3=SnowGetUiThemeColor()
                        data.label.Text=string.format("%.1f",math.max(remaining,0)); data.hadCountdown=true
                    end
                else
                    local data=active[player]
                    if not down then completed[player]=nil end
                    if data and data.hadCountdown and not data.readyUntil then
                        data.label.Text="READY!!!"; data.readyUntil=tick()+2
                    elseif data and data.readyUntil and tick()>=data.readyUntil then
                        clear(player)
                        if down then completed[player]=true end
                    elseif data and not data.hadCountdown then
                        clear(player)
                    end
                end
            end
        end
    end))
    table.insert(Dragon.enemyRagdollTimerConns,Players.PlayerRemoving:Connect(clear))
end

function espMakeLabel(plr)
    if not plr then return end
    espRemovePlayer(plr)

    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local isLocal = (plr == LP)
    if isLocal then return end

    -- SPEED BILLBOARD (all players including local)
    local bb = Instance.new("BillboardGui")
    bb.Name = "DragonESPSpeed"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 44)
    bb.StudsOffset = Vector3.new(0, isLocal and 3.0 or 3.6, 0)
    bb.MaxDistance = 2000
    bb.Parent = head

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "SpeedLabel"
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 22
    speedLbl.TextColor3 = isLocal and SnowGetUiThemeColor() or Color3.fromRGB(255,255,255)
    speedLbl.TextStrokeTransparency = 0.2
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    speedLbl.TextScaled = false
    speedLbl.Parent = bb
    if isLocal then
        -- Full Snow.VS-style overhead counter, recolored for Dragon.
        bb.Name = "DragonOverheadInfo"
        bb.Size = UDim2.new(0, 250, 0, 88)
        bb.StudsOffset = Vector3.new(0, 1.75, 0)
        bb.LightInfluence = 0
        local countdownLbl = Instance.new("TextLabel")
        countdownLbl.Name = "RagdollCountdown"; countdownLbl.Size = UDim2.new(1,0,0,26); countdownLbl.Position = UDim2.new(0,0,0,0)
        countdownLbl.BackgroundTransparency = 1; countdownLbl.Text = ""; countdownLbl.Visible = false; countdownLbl.TextColor3 = Color3.fromRGB(255,255,255)
        countdownLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0); countdownLbl.TextStrokeTransparency = 0; countdownLbl.Font = Enum.Font.GothamBlack; countdownLbl.TextSize = 22; countdownLbl.TextXAlignment = Enum.TextXAlignment.Center; countdownLbl.ZIndex = 10; countdownLbl.Parent = bb
        speedLbl.Size = UDim2.new(1,0,0,26)
        speedLbl.Position = UDim2.new(0,0,0,54)
        speedLbl.TextSize = 19
        speedLbl.TextColor3 = Color3.fromRGB(255,255,255)
        speedLbl.TextStrokeTransparency = 0
        speedLbl.TextXAlignment = Enum.TextXAlignment.Center
        speedLbl.ZIndex = 10
        local discordLbl = Instance.new("TextLabel")
        discordLbl.Name = "Discord"
        discordLbl.Size = UDim2.new(1,0,0,30)
        discordLbl.Position = UDim2.new(0,0,0,26)
        discordLbl.BackgroundTransparency = 1
        discordLbl.Text = "discord.gg/dragonhub"
        discordLbl.Font = Enum.Font.GothamBlack
        discordLbl.TextSize = 21
        discordLbl.TextColor3 = Color3.fromRGB(255,255,255)
        discordLbl.TextStrokeTransparency = 0
        discordLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        discordLbl.TextXAlignment = Enum.TextXAlignment.Center
        discordLbl.ZIndex = 10
        discordLbl.Parent = bb
    end

    local highlight, linePart = nil, nil
    if not isLocal then
        -- CHAMS
        highlight = Instance.new("Highlight")
        highlight.Name = "DragonChams"
        highlight.Adornee = char
        highlight.FillColor = SnowGetUiThemeColor()
        highlight.FillTransparency = 0.55
        highlight.OutlineColor = SnowGetUiThemeColor()
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        pcall(function() highlight.Parent = ESP.folder or workspace end)

        -- LINE
        linePart = Instance.new("Part")
        linePart.Name = "DragonESPLine"
        linePart.Anchored = true
        linePart.CanCollide = false
        linePart.CanQuery = false
        linePart.CanTouch = false
        linePart.CastShadow = false
        linePart.Material = Enum.Material.Neon
        linePart.Color = Color3.fromRGB(255,255,255)
        linePart.Transparency = 0.2
        linePart.Size = Vector3.new(0.05,0.05,1)
        pcall(function() linePart.Parent = ESP.folder or workspace end)

        local lineConn = RunService.RenderStepped:Connect(function()
            if not snowVisualUpdateDue("espLine_"..plr.UserId,0.07) then return end
            if not espEnabled then return end
            local myChar = LP.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local tHRP = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
            if not myHRP or not tHRP or not linePart or not linePart.Parent then return end
            local a = myHRP.Position
            local b = tHRP.Position
            local dist = (b - a).Magnitude
            linePart.Size = Vector3.new(0.05, 0.05, dist)
            linePart.CFrame = CFrame.lookAt((a+b)/2, b)
        end)
        table.insert(ESP.conns, lineConn)
    end

    -- Live speed update — horizontal studs/s (matches move speed)
    local speedConn = RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("espSpeed_"..plr.UserId,0.10) then return end
        if not espEnabled or not speedLbl or not speedLbl.Parent then return end
        local c = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp then
            speedLbl.Text = "Speed: 0"
            return
        end
        local v = hrp.AssemblyLinearVelocity
        -- horizontal only so jumps don't skew the number
        local hx, hz = v.X, v.Z
        local spd = math.sqrt(hx*hx + hz*hz)
        -- local player: if script speed is active and moving, prefer target speed so it matches settings
        if isLocal and hum and not isRagdollState(hum) then
            local md = hum.MoveDirection
            if md.Magnitude > 0.05 and not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
                local target = getActiveMoveSpeed and getActiveMoveSpeed() or nil
                if type(target) == "number" and target > 0 then
                    -- blend toward target so display matches what you set (61 etc.)
                    if spd > target * 0.55 then
                        spd = target
                    end
                end
            end
        end
        speedLbl.Text = string.format("Speed: %d", math.floor(spd + 0.5))
    end)
    table.insert(ESP.conns, speedConn)

    ESP.labels[plr] = {
        billboard = bb,
        highlight = highlight,
        line = linePart,
    }
end

function startESP()
    espEnabled = true
    espClear()
    ESP.folder = Instance.new("Folder")
    ESP.folder.Name = "DragonESPFolder"
    pcall(function() ESP.folder.Parent = workspace end)

    for _,plr in ipairs(Players:GetPlayers()) do
        espMakeLabel(plr)
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4)
            if espEnabled then espMakeLabel(plr) end
        end))
    end

    table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
        if not espEnabled then return end
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4)
            if espEnabled then espMakeLabel(plr) end
        end))
        if plr.Character then espMakeLabel(plr) end
    end))

    table.insert(ESP.conns, Players.PlayerRemoving:Connect(function(plr)
        espRemovePlayer(plr)
    end))
end

function stopESP()
    espEnabled = false
    espClear()
    -- also kill any orphan DragonESP billboards left in the world
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and (obj.Name=="DragonESPSpeed" or obj.Name:find("DragonESP")) then
                obj:Destroy()
            end
            if obj:IsA("Highlight") and obj.Name and tostring(obj.Name):find("DragonESP") then
                obj:Destroy()
            end
        end
    end)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BillboardGui") and (obj.Name=="DragonESPSpeed" or obj.Name:find("DragonESP")) then
                        obj:Destroy()
                    end
                end
            end
        end
    end)
end

-- Snow.VS-style ESP: compact speed/name tag plus chams.  The Dragon version uses
-- the cyan palette and intentionally has no avatar or tracer extras.
function espRemovePlayer(plr)
    local data = ESP.labels[plr]
    if not data then return end
    if data.conns then
        for _, conn in ipairs(data.conns) do pcall(function() conn:Disconnect() end) end
    end
    pcall(function() if data.billboard then data.billboard:Destroy() end end)
    pcall(function() if data.highlight then data.highlight:Destroy() end end)
    ESP.labels[plr] = nil
end

function espClear()
    for _, conn in ipairs(ESP.conns) do pcall(function() conn:Disconnect() end) end
    ESP.conns = {}
    for plr, _ in pairs(ESP.labels) do espRemovePlayer(plr) end
    ESP.labels = {}
    if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder = nil end
end

function espMakeLabel(plr)
    if not plr or plr == LP or not espEnabled then return end
    espRemovePlayer(plr)
    local char = plr.Character
    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5))
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    if not hrp or not head then return end

    local hl = Instance.new("Highlight")
    hl.Name = "DragonESP"
    hl.Adornee = char
    hl.FillColor = SnowGetUiThemeColor()
    hl.FillTransparency = 0.4
    hl.OutlineColor = SnowGetUiThemeColor()
    hl.OutlineTransparency = 1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char

    local bb = Instance.new("BillboardGui")
    bb.Name = "DragonESPTag"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 124, 0, 34)
    bb.StudsOffset = Vector3.new(0, 2.7, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = head
    -- Enemy Speed owns the speed billboard; the master ESP only renders chams.
    bb.Enabled = false
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = bb
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 9)
    local speed = Instance.new("TextLabel")
    speed.Size = UDim2.new(1, -10, 0, 17)
    speed.Position = UDim2.new(0, 5, 0, 2)
    speed.BackgroundTransparency = 1
    speed.Text = plr.Name
    speed.TextColor3 = SnowGetUiThemeColor()
    speed.Font = Enum.Font.GothamBlack
    speed.TextSize = 15
    speed.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speed.TextStrokeTransparency = 0.38
    speed.Parent = box
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -10, 0, 11)
    name.Position = UDim2.new(0, 5, 0, 19)
    name.BackgroundTransparency = 1
    name.Text = plr.Name
    name.TextColor3 = SnowGetUiThemeColor()
    name.Font = Enum.Font.GothamBold
    name.TextSize = 10
    name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    name.TextStrokeTransparency = 0.58
    name.Visible = false
    name.Parent = box
    local conn = RunService.Heartbeat:Connect(function()
        if not espEnabled or not hrp.Parent then return end
        speed.Text = plr.Name
    end)
    ESP.labels[plr] = {billboard = bb, highlight = hl, conns = {conn}}
end

function startESP()
    if espEnabled and #ESP.conns > 0 then return end
    espEnabled = true
    espClear()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if plr.Character then espMakeLabel(plr) end
            table.insert(ESP.conns, plr.CharacterAdded:Connect(function(char)
                task.defer(espMakeLabel, plr)
            end))
        end
    end
    table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
        if plr == LP then return end
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function(char)
            task.defer(espMakeLabel, plr)
        end))
    end))
    table.insert(ESP.conns, Players.PlayerRemoving:Connect(espRemovePlayer))
end

function enemySpeedRemovePlayer(plr)
    local data = EnemySpeedESP.labels[plr]
    if not data then return end
    if data.conn then pcall(function() data.conn:Disconnect() end) end
    pcall(function() if data.billboard then data.billboard:Destroy() end end)
    EnemySpeedESP.labels[plr] = nil
end

function enemySpeedMakeLabel(plr)
    if not enemySpeedEnabled or not plr or plr == LP then return end
    enemySpeedRemovePlayer(plr)
    local char = plr.Character
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5))
    if not head or not hrp then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "SnowEnemySpeed"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 124, 0, 22)
    bb.StudsOffset = Vector3.new(0, 3.35, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 15
    label.TextColor3 = SnowGetUiThemeColor()
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.38
    label.Parent = bb
    local conn = RunService.Heartbeat:Connect(function()
        if not enemySpeedEnabled or not hrp.Parent then return end
        local v = hrp.AssemblyLinearVelocity or hrp.Velocity
        label.Text = string.format("%d speed", math.floor(Vector3.new(v.X, 0, v.Z).Magnitude + 0.5))
    end)
    EnemySpeedESP.labels[plr] = {billboard=bb, conn=conn}
end

function startEnemySpeedESP()
    if enemySpeedEnabled and #EnemySpeedESP.conns > 0 then return end
    enemySpeedEnabled = true
    stopEnemySpeedESP()
    enemySpeedEnabled = true
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if plr.Character then enemySpeedMakeLabel(plr) end
            table.insert(EnemySpeedESP.conns, plr.CharacterAdded:Connect(function() task.defer(enemySpeedMakeLabel, plr) end))
        end
    end
    table.insert(EnemySpeedESP.conns, Players.PlayerAdded:Connect(function(plr)
        if plr ~= LP then table.insert(EnemySpeedESP.conns, plr.CharacterAdded:Connect(function() task.defer(enemySpeedMakeLabel, plr) end)) end
    end))
    table.insert(EnemySpeedESP.conns, Players.PlayerRemoving:Connect(enemySpeedRemovePlayer))
end

function stopEnemySpeedESP()
    enemySpeedEnabled = false
    for _, conn in ipairs(EnemySpeedESP.conns) do pcall(function() conn:Disconnect() end) end
    EnemySpeedESP.conns = {}
    for plr, _ in pairs(EnemySpeedESP.labels) do enemySpeedRemovePlayer(plr) end
    EnemySpeedESP.labels = {}
end

function clearSnowExtraESP()
    for _, data in pairs(SnowExtraESP.boxData) do
        pcall(function() if data.box then data.box:Destroy() end end)
    end
    for _, data in pairs(SnowExtraESP.lineData) do pcall(function() if data.line then data.line:Destroy() end end) end
    pcall(function() if SnowExtraESP.screen then SnowExtraESP.screen:Destroy() end end)
    SnowExtraESP.screen=nil
    SnowExtraESP.boxData = {}
    SnowExtraESP.lineData = {}
end

function refreshSnowExtraESP()
    local needsVisuals=espEnabled and (espBoxEnabled or espLineEnabled)
    if not needsVisuals then
        if SnowExtraESP.conn then pcall(function() SnowExtraESP.conn:Disconnect() end); SnowExtraESP.conn = nil end
        clearSnowExtraESP()
        return
    end
    if SnowExtraESP.conn then return end
    local screen=Instance.new("ScreenGui")
    screen.Name="DragonVisualESP"; screen.ResetOnSpawn=false; screen.IgnoreGuiInset=true; screen.DisplayOrder=999
    screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function() screen.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
    if not screen.Parent then screen.Parent=LP:WaitForChild("PlayerGui") end
    SnowExtraESP.screen=screen
    SnowExtraESP.conn = RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("extraESP",0.08) then return end
        local cam = workspace.CurrentCamera
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not cam or not myRoot then return end
        local seen = {}
        -- Tracers are deliberately anchored to the local HumanoidRootPart
        -- (the character's pelvis), rather than an arbitrary screen point.
        local from3=cam:WorldToViewportPoint(myRoot.Position)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local head = char and char:FindFirstChild("Head")
                if root and head then
                    seen[plr] = true
                    local root2, rootOn = cam:WorldToViewportPoint(root.Position)
                    local head2, headOn = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.55, 0))
                    local data=SnowExtraESP.boxData[plr]
                    if not data then
                        local box=Instance.new("Frame",screen); box.Name="ESP_BOX_"..plr.Name; box.BackgroundTransparency=1; box.BorderSizePixel=0; box.Visible=false; box.ZIndex=9999
                        local stroke=Instance.new("UIStroke",box); stroke.Name="Stroke"; stroke.Thickness=1.5; stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                        data={box=box,stroke=stroke}; SnowExtraESP.boxData[plr]=data
                    end
                    local accent=SnowGetUiThemeColor(); data.stroke.Color=accent
                    local height=math.abs(head2.Y-root2.Y)*2.15; if height<20 or height~=height then height=65 end
                    local width=height*.55
                    local onScreen=rootOn and headOn and root2.Z>0 and head2.Z>0
                    data.box.Position=UDim2.fromOffset(root2.X-width/2,root2.Y-height/2); data.box.Size=UDim2.fromOffset(width,height); data.box.Visible=espBoxEnabled and onScreen
                    if espLineEnabled then
                        local lineData=SnowExtraESP.lineData[plr]
                        if not lineData then local line=Instance.new("Frame",screen); line.Name="ESP_TRACER_"..plr.Name; line.AnchorPoint=Vector2.new(.5,.5); line.BorderSizePixel=0; line.ZIndex=9998; lineData={line=line}; SnowExtraESP.lineData[plr]=lineData end
                        local dx,dy=root2.X-from3.X,root2.Y-from3.Y; local length=math.sqrt(dx*dx+dy*dy)
                        lineData.line.BackgroundColor3=accent; lineData.line.BackgroundTransparency=.05; lineData.line.Position=UDim2.fromOffset((from3.X+root2.X)/2,(from3.Y+root2.Y)/2); lineData.line.Size=UDim2.fromOffset(length,1); lineData.line.Rotation=math.deg(math.atan2(dy,dx)); lineData.line.Visible=onScreen and length>1
                    elseif SnowExtraESP.lineData[plr] then SnowExtraESP.lineData[plr].line.Visible=false end
                end
            end
        end
        for plr,data in pairs(SnowExtraESP.boxData) do if not seen[plr] then pcall(function() data.box:Destroy() end); SnowExtraESP.boxData[plr]=nil end end
        for plr,data in pairs(SnowExtraESP.lineData) do if not seen[plr] then pcall(function() data.line:Destroy() end); SnowExtraESP.lineData[plr]=nil end end
    end)
end

-- ============================================================
-- MOBILE BUTTON POSITIONS
-- ============================================================
MOB_POS_FILE=Dragon_BUTTONS_FILE
function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local grp=mobGuiRef:FindFirstChild("MobileButtons")
    if not grp then return end
    local out={__group={xs=grp.Position.X.Scale,xo=grp.Position.X.Offset,ys=grp.Position.Y.Scale,yo=grp.Position.Y.Offset}}
    for _,ch in ipairs(grp:GetChildren()) do
        if ch:IsA("Frame") then
            out[ch.Name]={xo=ch.Position.X.Offset,yo=ch.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

refreshSpeedModeLabel,saveConfig = nil,nil
startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter = nil,nil,nil,nil
startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight = nil,nil,nil,nil,nil,nil
startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez = nil,nil,nil,nil,nil,nil
startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,runAutoAfterDrop = nil,nil,nil,nil,nil,nil
startAutoSteal,stopAutoSteal,toggleCarryMode,toggleLaggerMode = nil,nil,nil,nil

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("fov",0.12) then return end
        local cam=workspace.CurrentCamera; if cam then cam.FieldOfView=fovValue end
    end)
end

function SnowRefreshHitCircleTheme()
    local part=SnowHitCircle and SnowHitCircle.part
    if part and part.Parent then part.Color=SnowGetUiThemeColor() end
end
function SnowSetHitCircle(on)
    hitCircleEnabled=on==true
    local state=SnowHitCircle
    if not hitCircleEnabled then
        if state.conn then pcall(function() state.conn:Disconnect() end); state.conn=nil end
        if state.part then pcall(function() state.part:Destroy() end); state.part=nil end
        return
    end
    if not state.part or not state.part.Parent then
        local part=Instance.new("Part")
        part.Name="SnowHitCircle"; part.Shape=Enum.PartType.Cylinder; part.Anchored=true; part.CanCollide=false; part.CanQuery=false; part.CanTouch=false; part.CastShadow=false; part.Material=Enum.Material.Neon; part.Transparency=.72; part.Parent=workspace.CurrentCamera
        state.part=part
    end
    SnowRefreshHitCircleTheme()
    if state.conn then pcall(function() state.conn:Disconnect() end) end
    state.conn=RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("hitCircle",0.05) then return end
        if not hitCircleEnabled then return end
        local character=LP.Character; local root=character and character:FindFirstChild("HumanoidRootPart"); local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local part=state.part
        if not root or not humanoid or not part or not part.Parent then return end
        local radius=state.radius
        part.Size=Vector3.new(.12,radius*2,radius*2)
        -- Same floor alignment used by Ambitious' Radius Circle.
        local footY=root.Position.Y-(root.Size.Y*.5)-humanoid.HipHeight
        local previous=state.lastFootY
        if previous and math.abs(footY-previous)<1.5 then footY=previous+(footY-previous)*.4 end
        state.lastFootY=footY
        part.CFrame=CFrame.new(root.Position.X,footY+.2,root.Position.Z)*CFrame.Angles(0,0,math.rad(90))
        part.Color=SnowGetUiThemeColor()
    end)
end

function applySnowAmbitiousVisualEffects()
    local lighting=game:GetService("Lighting")
    local oldColor=lighting:FindFirstChild("SnowColorfulGraphics")
    if oldColor then oldColor:Destroy() end
    local oldBlur=lighting:FindFirstChild("SnowMotionBlur")
    if oldBlur then oldBlur:Destroy() end
    snowColorfulEffect=nil; snowMotionBlur=nil
    if colorfulGraphicsEnabled then
        snowColorfulEffect=Instance.new("ColorCorrectionEffect"); snowColorfulEffect.Name="SnowColorfulGraphics"; snowColorfulEffect.Saturation=.32; snowColorfulEffect.Contrast=.12; snowColorfulEffect.TintColor=Color3.fromRGB(190,225,255); snowColorfulEffect.Parent=lighting
    end
    if motionBlurEnabled then
        snowMotionBlur=Instance.new("BlurEffect"); snowMotionBlur.Name="SnowMotionBlur"; snowMotionBlur.Size=7; snowMotionBlur.Parent=lighting
    end
end
applyFOV()

function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local WHITE=Color3.fromRGB(255,255,255)
    local BG=Color3.fromRGB(12,5,10)
    local W,H=210,80
    local guiName="SnowRagdollTimer_"..labelText
    pcall(function()
        local cg=game:GetService("CoreGui"); local old=cg:FindFirstChild(guiName); if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui"); if pg then local o=pg:FindFirstChild(guiName); if o then o:Destroy() end end
    end)
    local sg=Instance.new("ScreenGui")
    sg.Name=guiName; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=25
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then sg.Parent=LP:WaitForChild("PlayerGui") end
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,W,0,H); card.Position=UDim2.new(0.5,-W/2,0,58)
    card.BackgroundColor3=BG; card.BackgroundTransparency=1
    card.BorderSizePixel=0; card.ZIndex=30; card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local stroke=Instance.new("UIStroke",card)
    stroke.Color=WHITE; stroke.Thickness=3; stroke.Transparency=1
    task.spawn(function()
        local t=0
        while stroke and stroke.Parent do
            t=t+0.05
            stroke.Transparency=0.02+math.abs(math.sin(t*2.5))*0.25
            stroke.Color=Color3.fromRGB(255,255,255)
            task.wait(0.04)
        end
    end)
    local titleLbl=Instance.new("TextLabel",card)
    titleLbl.Size=UDim2.new(1,-16,0,28); titleLbl.Position=UDim2.new(0,8,0,6)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=(labelText=="RAGDOLL" and "RAGDOLL TIMER" or labelText.." TIMER")
    titleLbl.TextColor3=WHITE; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=13
    titleLbl.TextXAlignment=Enum.TextXAlignment.Center; titleLbl.ZIndex=32
    local divider=Instance.new("Frame",card)
    divider.Size=UDim2.new(1,-20,0,1); divider.Position=UDim2.new(0,10,0,34)
    divider.BackgroundColor3=WHITE; divider.BackgroundTransparency=0.5; divider.BorderSizePixel=0; divider.ZIndex=31
    local timerLbl=Instance.new("TextLabel",card)
    timerLbl.Size=UDim2.new(1,0,0,H-38); timerLbl.Position=UDim2.new(0,0,0,36)
    timerLbl.BackgroundTransparency=1; timerLbl.Text=string.format("%.1f",duration).."s"
    timerLbl.TextColor3=WHITE; timerLbl.Font=Enum.Font.GothamBlack; timerLbl.TextSize=24
    timerLbl.TextXAlignment=Enum.TextXAlignment.Center; timerLbl.ZIndex=32
    local shimmer=addShimmerToLabel(timerLbl,WHITE,WHITE)
    task.spawn(function() local t=0; while timerLbl and timerLbl.Parent do t=t+0.04; shimmer.Offset=Vector2.new(math.sin(t)*0.5,0); task.wait(0.04) end end)
    local dragStart,dragStartPos,dragging=nil,nil,false
    card.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; dragStartPos=card.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            card.Position=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
        end
    end)
    local startTime=tick(); local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then conn:Disconnect(); pcall(function() sg:Destroy() end)
        elseif timerLbl and timerLbl.Parent then timerLbl.Text=string.format("%.1f",remaining).."s" end
    end)
    return sg
end

function onHumanoidStateChanged(old,new)
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    -- Aimbot After Hit: when ragdolled by a hit, auto-start bat aimbot
    -- NEVER enable during duel countdown (even if ragdolled in countdown)
    if isRag and aimbotAfterHitEnabled and snowWasHitByBat(char) and not autoBatEnabled and not aimbotAfterHitDebounce then
        aimbotAfterHitDebounce=true
        task.spawn(function()
            task.wait(0.15)
            if not aimbotAfterHitEnabled then
                aimbotAfterHitDebounce=false
                return
            end
            -- Block while countdown is showing (GO / READY / START / 10..0)
            local inCountdown=false
            pcall(function()
                if SafeMode and SafeMode.inDuelCountdown then
                    inCountdown=SafeMode.inDuelCountdown()
                end
            end)
            if inCountdown then
                aimbotAfterHitDebounce=false
                return
            end
            if Dragon.tpBat then
                aimbotAfterHitDebounce=false
                return
            end
            if not autoBatEnabled and queueAutoBatStart then
                local started=queueAutoBatStart()
                -- Bat Counter V2 is a single counter-attack, not a permanent aimbot.
                if started and DragonAimbot then DragonAimbot.stopAfterHit=true end
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            end
            task.delay(2.5,function() aimbotAfterHitDebounce=false end)
        end)
    end
end
-- The countdown is intentionally driven only by the confirmed Clean
-- anti-ragdoll detectors below, never by a generic Humanoid StateChanged.
Dragon.cleanRagdollAlert=function()
    if activeBatBillboard then return end
    activeBatBillboard=true
    showSnowRagdollCountdown()
    task.delay(2.6,function() activeBatBillboard=nil end)
end
function setupRagdollTriggers()
    local char=LP.Character; if not char then return end
    snowTrackBatContact(char)
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(onHumanoidStateChanged)
    end
end
function setupSpeedIndicator(char) end
function getActiveMoveSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

-- ====================== SPEED (Snow no-drop, updated wall/roof handling) ======================
-- Snow's original high-force system, with the current safe wall/roof stops.
local CleanCarrySystem={lv=nil,attachment=nil,character=nil,blockedTime=0,maxForce=1000000,freeForce=1000000,rayParams=nil,rayFilter=nil,lastFilterAt=0}
local snowAutoLeftWallGuard={}
local snowAutoRightWallGuard={}

local function cleanDestroySpeed()
    if CleanCarrySystem.lv then pcall(function() CleanCarrySystem.lv:Destroy() end) end
    if CleanCarrySystem.attachment then pcall(function() CleanCarrySystem.attachment:Destroy() end) end
    CleanCarrySystem.lv=nil; CleanCarrySystem.attachment=nil; CleanCarrySystem.character=nil
end

local function cleanSetupSpeed(character)
    if not character then return false end
    local root=character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart",5)
    if not root then return false end
    if CleanCarrySystem.lv and CleanCarrySystem.lv.Parent==root and CleanCarrySystem.character==character then
        CleanCarrySystem.lv.Enabled=true
        return true
    end
    cleanDestroySpeed()
    local attachment=Instance.new("Attachment")
    attachment.Name="SnowHazeLinVelAtt0"; attachment.Parent=root
    local linearVelocity=Instance.new("LinearVelocity")
    linearVelocity.Name="SnowHazeLinVel"
    linearVelocity.Attachment0=attachment
    linearVelocity.VelocityConstraintMode=Enum.VelocityConstraintMode.Plane
    linearVelocity.PrimaryTangentAxis=Vector3.new(1,0,0)
    linearVelocity.SecondaryTangentAxis=Vector3.new(0,0,1)
    linearVelocity.RelativeTo=Enum.ActuatorRelativeTo.World
    linearVelocity.MaxForce=CleanCarrySystem.maxForce
    linearVelocity.PlaneVelocity=Vector2.zero
    linearVelocity.Parent=root
    CleanCarrySystem.lv=linearVelocity; CleanCarrySystem.attachment=attachment; CleanCarrySystem.character=character
    pcall(function() root:SetNetworkOwner(LP) end)
    return true
end

local function snowSetVelocity(x,z)
    local lv=CleanCarrySystem.lv
    if lv and lv.Parent then pcall(function() lv.PlaneVelocity=Vector2.new(x,z) end) end
end
local function snowClearVelocity()
    local lv=CleanCarrySystem.lv
    if lv and lv.Parent then pcall(function() lv.PlaneVelocity=Vector2.zero end) end
end
local function snowEnsureVelocity()
    return cleanSetupSpeed(LP.Character)
end
local function snowSuspendVelocity()
    local lv=CleanCarrySystem.lv
    if lv and lv.Parent then pcall(function() lv.PlaneVelocity=Vector2.zero; lv.Enabled=false end) end
end
-- Original Snow compatibility layer: game-side velocity reads see the idle
-- value while the local Plane LinearVelocity handles movement.
local snowSpeedSpoofVelocity=Vector3.zero
if not _snowSpeedSpoofHooked then
    pcall(function()
        if not (getrawmetatable and setreadonly and newcclosure) then return end
        local mt=getrawmetatable(game); setreadonly(mt,false)
        local oldIndex=mt.__index
        mt.__index=newcclosure(function(self,key)
            if (not checkcaller or not checkcaller()) and (key=="AssemblyLinearVelocity" or key=="Velocity") and typeof(self)=="Instance" and self:IsA("BasePart") and self.Name=="HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then return snowSpeedSpoofVelocity end
            return oldIndex(self,key)
        end)
        local oldNewIndex=mt.__newindex
        mt.__newindex=newcclosure(function(self,key,value)
            if (not checkcaller or not checkcaller()) and (key=="AssemblyLinearVelocity" or key=="Velocity") and typeof(self)=="Instance" and self:IsA("BasePart") and self.Name=="HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then return end
            return oldNewIndex(self,key,value)
        end)
        setreadonly(mt,true); _snowSpeedSpoofHooked=true
    end)
end
if _snowSpeedSpoofConn then pcall(function() _snowSpeedSpoofConn:Disconnect() end) end
_snowSpeedSpoofConn=RunService.Heartbeat:Connect(function() snowSpeedSpoofVelocity=Vector3.zero end)
local function snowSetupLinearVelocity(character)
    cleanSetupSpeed(character)
end

-- Auto Left/Right still call this compatibility function, but it no longer
-- contains Snow's old wall/roof protection logic.
local function snowApplySafePath(character,root,humanoid,direction,speed)
    local flat=Vector3.new(direction.X,0,direction.Z)
    if flat.Magnitude<0.01 then humanoid:Move(Vector3.zero,false); snowClearVelocity(); return false end
    local unit=flat.Unit
    humanoid:Move(unit,false)
    if snowEnsureVelocity() then snowSetVelocity(unit.X*speed,unit.Z*speed) end
    return true
end

local function cleanWallNormal(character,root,moveDirection)
    local flat=Vector3.new(moveDirection.X,0,moveDirection.Z)
    if flat.Magnitude<0.1 then return nil end
    if not CleanCarrySystem.rayParams then
        CleanCarrySystem.rayParams=RaycastParams.new()
        CleanCarrySystem.rayParams.FilterType=Enum.RaycastFilterType.Exclude
        CleanCarrySystem.rayFilter={}
    end
    local now=tick()
    if now-CleanCarrySystem.lastFilterAt>.75 then
        CleanCarrySystem.lastFilterAt=now
        local filter=CleanCarrySystem.rayFilter
        table.clear(filter); table.insert(filter,character)
        for _,player in ipairs(Players:GetPlayers()) do if player.Character then table.insert(filter,player.Character) end end
        CleanCarrySystem.rayParams.FilterDescendantsInstances=filter
    end
    -- Check the root and both shoulder offsets.  A single center ray misses
    -- sharp corners, so high speed could still push the character into an edge
    -- and trigger the game's ragdoll before the next frame.
    local direction=flat.Unit
    local right=Vector3.new(-direction.Z,0,direction.X)
    local origins={
        root.Position+Vector3.new(0,.45,0),
        root.Position+right*.85+Vector3.new(0,1.25,0),
        root.Position-right*.85+Vector3.new(0,1.25,0),
    }
    local nearestNormal=nil
    for _,origin in ipairs(origins) do
        local hit=workspace:Raycast(origin,direction*3.2,CleanCarrySystem.rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            local normal=Vector3.new(hit.Normal.X,0,hit.Normal.Z)
            if normal.Magnitude>.35 then
                nearestNormal=normal.Unit
                break
            end
        end
    end
    return nearestNormal
end
local function cleanRoofBlocked(character,root,humanoid)
    local head=character:FindFirstChild("Head")
    local rising=root.AssemblyLinearVelocity.Y>1 or humanoid:GetState()==Enum.HumanoidStateType.Jumping
    if not head or not rising then return false end
    local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances={character}; params.IgnoreWater=true
    local clearance=math.max(head.Size.Y*.5+.45,1.2)
    -- Probe the center plus the four corners of the head: sloped roofs and
    -- roof edges often miss a center-only cast.
    local halfX=head.Size.X*.42
    local halfZ=head.Size.Z*.42
    for _,offset in ipairs({Vector3.zero,Vector3.new(halfX,0,halfZ),Vector3.new(halfX,0,-halfZ),Vector3.new(-halfX,0,halfZ),Vector3.new(-halfX,0,-halfZ)}) do
        local hit=workspace:Raycast(head.Position+offset,Vector3.new(0,clearance,0),params)
        if hit and hit.Instance and hit.Instance.CanCollide then return true end
    end
    return false
end

-- Dragon roof guard: only runs while travelling upward, checks the clearance
-- above the root, then briefly holds vertical movement at zero.
local dragonSpeedRoofParams=RaycastParams.new()
dragonSpeedRoofParams.FilterType=Enum.RaycastFilterType.Exclude
dragonSpeedRoofParams.IgnoreWater=true
pcall(function() dragonSpeedRoofParams.RespectCanCollide=true end)
local function dragonSpeedRoofGuard(root,dt)
    if not root or not root.Parent or dropActive then return false end
    local rise=math.max(root.AssemblyLinearVelocity.Y,0)
    if rise<=.25 then return false end
    dragonSpeedRoofParams.FilterDescendantsInstances={root.Parent}
    local step=math.clamp(dt or 1/60,1/240,1/15)
    if not workspace:Raycast(root.Position,Vector3.new(0,3.05+math.min(rise*step,.9),0),dragonSpeedRoofParams) then return false end
    snowClearVelocity(); snowSpeedSpoofVelocity=Vector3.zero
    pcall(function()
        local current=root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity=Vector3.new(0,0,0)
        root.AssemblyAngularVelocity=Vector3.zero
    end)
    local attachment=root:FindFirstChild("DragonVampireRoofGuardAttachment") or Instance.new("Attachment")
    attachment.Name="DragonVampireRoofGuardAttachment"; attachment.Parent=root
    local pulse=root:FindFirstChild("DragonVampireRoofGuardLinearVelocity")
    if not pulse then
        pulse=Instance.new("LinearVelocity"); pulse.Name="DragonVampireRoofGuardLinearVelocity"; pulse.Attachment0=attachment; pulse.RelativeTo=Enum.ActuatorRelativeTo.World
        pulse.VelocityConstraintMode=Enum.VelocityConstraintMode.Line; pulse.LineDirection=Vector3.new(0,1,0); pulse.ForceLimitsEnabled=false; pulse.Parent=root
    end
    local token=os.clock(); pulse:SetAttribute("DragonPulse",token); pulse.LineVelocity=0; pulse.Enabled=true
    task.delay(.14,function()
        if pulse.Parent and pulse:GetAttribute("DragonPulse")==token then pcall(function() pulse:Destroy() end) end
        if attachment.Parent and not root:FindFirstChild("DragonVampireRoofGuardLinearVelocity") then pcall(function() attachment:Destroy() end) end
    end)
    return true
end

-- Dragon wall resolver: spherecasts in the desired direction and removes only
-- the component that pushes into a non-walkable surface, allowing a slide.
local dragonSpeedWallGuard={normal=nil,expires=0}
local function dragonSpeedResolveHorizontal(root,humanoid,desired,dt)
    local vector=Vector3.new(desired.X,0,desired.Z)
    if vector.Magnitude<.01 then return Vector3.zero end
    local now=os.clock()
    if dragonSpeedWallGuard.normal and now<dragonSpeedWallGuard.expires and vector:Dot(dragonSpeedWallGuard.normal)<-.01 then
        return Vector3.zero
    elseif now>=dragonSpeedWallGuard.expires then
        dragonSpeedWallGuard.normal=nil
    end
    dragonSpeedRoofParams.FilterDescendantsInstances={root.Parent}
    local frameStep=math.clamp(math.max(dt or 1/60,1/90),1/90,1/15)
    local radius=math.clamp(math.max(root.Size.X,root.Size.Z)*.5,.9,1)
    local originalMagnitude=vector.Magnitude
    for _=1,2 do
        if vector.Magnitude<.02 then break end
        local distance=vector.Magnitude*frameStep
        local hit=nil
        local ok=pcall(function() hit=workspace:Spherecast(root.Position,radius,vector.Unit*(distance+.03),dragonSpeedRoofParams) end)
        if not ok then hit=workspace:Raycast(root.Position,vector.Unit*(distance+radius+.03),dragonSpeedRoofParams) end
        if not hit then break end
        local slope=math.cos(math.rad(math.clamp(humanoid.MaxSlopeAngle or 45,0,89)))
        if hit.Normal.Y>=slope then break end
        local normal=Vector3.new(hit.Normal.X,0,hit.Normal.Z)
        if normal.Magnitude<.05 then break end
        normal=normal.Unit
        local into=vector:Dot(normal)
        if into>=0 then break end
        vector=vector-normal*into
        if vector.Magnitude<.04 then
            dragonSpeedWallGuard.normal=normal
            dragonSpeedWallGuard.expires=now+.22
            return Vector3.zero
        end
    end
    if vector.Magnitude<.04 then return Vector3.zero end
    return vector.Magnitude>originalMagnitude and vector.Unit*originalMagnitude or vector
end

if _snowSpeedEngineConn then pcall(function() _snowSpeedEngineConn:Disconnect() end) end
_snowSpeedEngineConn=RunService.Heartbeat:Connect(function(dt)
    local character=LP.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    local state=humanoid:GetState()
    local ragdolled=state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown
    -- Match Clean's separation of responsibilities: during ragdoll recovery
    -- speed is completely paused, and the LinearVelocity never writes Y force.
    -- This prevents speed/anti-ragdoll fighting when touching a ceiling.
    if ragdolled or (Dragon and Dragon.cleanRagdollRecovering) then
        snowSuspendVelocity(); CleanCarrySystem.blockedTime=0
        if CleanCarrySystem.lv then CleanCarrySystem.lv.MaxForce=CleanCarrySystem.maxForce end
        return
    end
    if dragonSpeedRoofGuard(root,dt) then return end
    if autoLeftEnabled or autoRightEnabled then return end
    if dropActive or autoBatEnabled or batV2Enabled or (Dragon and (Dragon.tpBat or Dragon.batV2 or Dragon.tpBatSpeedResumePending)) or (SnowMessage19TPBat and SnowMessage19TPBat.enabled) then
        snowSuspendVelocity()
        if Dragon and Dragon.tpBatSpeedResumePending and tick()>=(Dragon.tpBatSpeedResumeAt or 0) then Dragon.tpBatSpeedResumePending=false end
        return
    end
    if not snowEnsureVelocity() then return end
    local lv=CleanCarrySystem.lv
    if not lv then return end
    -- Keep the horizontal LinearVelocity enabled. Anti-Bat scripts can
    -- briefly overwrite root velocity, but this constraint keeps the selected
    -- DUELS speed authoritative instead of falling back to a game-side value.
    lv.Enabled=true
    local moveDirection=humanoid.MoveDirection
    if moveDirection.Magnitude<.1 then
        snowClearVelocity(); snowSpeedSpoofVelocity=Vector3.zero; CleanCarrySystem.blockedTime=0; return
    end
    local speed=tonumber(getActiveMoveSpeed()) or NS
    local flat=Vector3.new(moveDirection.X,0,moveDirection.Z).Unit
    local velocity=dragonSpeedResolveHorizontal(root,humanoid,flat*speed,dt)
    CleanCarrySystem.blockedTime=0
    pcall(function() root:SetNetworkOwner(LP) end)
    local current=root.AssemblyLinearVelocity
    local shown=flat*math.min(speed,16)
    snowSpeedSpoofVelocity=Vector3.new(shown.X,math.clamp(current.Y,-20,20),shown.Z)
    -- Use the persistent plane constraint rather than writing root velocity.
    -- This prevents Anti Bat's one-frame velocity desync from overwriting speed.
    snowSetVelocity(velocity.X,velocity.Z)
end)

if _snowSpeedRespawnConn then pcall(function() _snowSpeedRespawnConn:Disconnect() end) end
_snowSpeedRespawnConn=LP.CharacterAdded:Connect(function(character)
    task.wait(.35)
    cleanSetupSpeed(character)
end)
task.defer(function() task.wait(.2); cleanSetupSpeed(LP.Character) end)
-- ====================== ANTI DIE (global) ======================
-- This is intentionally independent from TP Bat.  TP Bat suspends this
-- protection while active and uses its own optional Anti Die toggle instead.
function Dragon.clearGlobalAntiDie()
    local state=Dragon._globalAntiDie
    if not state then return end
    for _,key in ipairs({"healthConn","deathConn","charConn"}) do
        if state[key] then pcall(function() state[key]:Disconnect() end); state[key]=nil end
    end
    local humanoid=state.humanoid
    if humanoid and humanoid.Parent then
        pcall(function()
            humanoid.BreakJointsOnDeath=true
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,true)
        end)
    end
    state.humanoid=nil
end

function Dragon.setupGlobalAntiDie(character)
    local state=Dragon._globalAntiDie or {}; Dragon._globalAntiDie=state
    for _,key in ipairs({"healthConn","deathConn"}) do
        if state[key] then pcall(function() state[key]:Disconnect() end); state[key]=nil end
    end
    if not antiDieEnabled or Dragon.tpBat or not character then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",5)
    if not humanoid then return end
    state.humanoid=humanoid
    state.reviving=false
    pcall(function() humanoid.BreakJointsOnDeath=false; humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false); humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,false) end)
    state.healthConn=humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if antiDieEnabled and not Dragon.tpBat and humanoid.Parent and humanoid.Health<=0 and not state.reviving then
            state.reviving=true
            pcall(function() humanoid.Health=humanoid.MaxHealth; humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false); humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
            task.delay(.2,function() state.reviving=false end)
        end
    end)
    state.deathConn=humanoid.Died:Connect(function()
        if not antiDieEnabled or Dragon.tpBat or not humanoid.Parent or state.reviving then return end
        state.reviving=true
        task.defer(function()
            if antiDieEnabled and not Dragon.tpBat and character.Parent and humanoid.Parent then pcall(function() humanoid.Health=humanoid.MaxHealth; humanoid:ChangeState(Enum.HumanoidStateType.Running) end) end
            state.reviving=false
        end)
    end)
end

function Dragon.setGlobalAntiDie(enabled)
    antiDieEnabled=enabled==true
    Dragon.clearGlobalAntiDie()
    if not antiDieEnabled or Dragon.tpBat then return end
    local state=Dragon._globalAntiDie or {}; Dragon._globalAntiDie=state
    Dragon.setupGlobalAntiDie(LP.Character)
    state.charConn=LP.CharacterAdded:Connect(function(character)
        task.wait(.05)
        Dragon.setupGlobalAntiDie(character)
    end)
end
Dragon.setGlobalAntiDie(antiDieEnabled)

function getAutoPathSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    else return NS end
end

-- Dragon AutoPlay arrival logic: stop only once the target is close and the
-- current horizontal momentum is safe, then taper speed near a waypoint.
local function dragonAutoPathMove(root,humanoid,target,speed)
    local here=Vector3.new(root.Position.X,0,root.Position.Z)
    local goal=Vector3.new(target.X,0,target.Z)
    local delta=goal-here
    local distance=delta.Magnitude
    local current=root.AssemblyLinearVelocity
    local horizontal=Vector3.new(current.X,0,current.Z)
    if distance<=1.1 and (horizontal.Magnitude<28 or distance<=.4) then
        humanoid:Move(Vector3.zero,false); snowClearVelocity(); snowSpeedSpoofVelocity=Vector3.zero
        return true
    end
    if distance<.001 then return false end
    local direction=delta.Unit
    local travelSpeed=tonumber(speed) or NS
    if distance<1.5 then travelSpeed=travelSpeed*math.clamp(distance/1.5,.6,1) end
    local wanted=dragonSpeedResolveHorizontal(root,humanoid,direction*travelSpeed,1/60)
    if wanted.Magnitude<.04 then
        humanoid:Move(Vector3.zero,false); snowClearVelocity(); snowSpeedSpoofVelocity=Vector3.zero
        return false
    end
    direction=wanted.Unit; travelSpeed=wanted.Magnitude
    humanoid.AutoRotate=true; humanoid:Move(direction,false)
    pcall(function() root:SetNetworkOwner(LP) end)
    snowSpeedSpoofVelocity=Vector3.new(direction.X*math.min(travelSpeed,16),math.clamp(current.Y,-20,20),direction.Z*math.min(travelSpeed,16))
    -- Auto Left/Right share the same persistent speed actuator as normal
    -- movement, so they keep working even while Anti Bat changes root velocity.
    if snowEnsureVelocity() and CleanCarrySystem.lv then
        CleanCarrySystem.lv.Enabled=true
        snowSetVelocity(wanted.X,wanted.Z)
    end
    return false
end
_autoSwitchWasSteal=false
function isStealState()
    local char=LP.Character
    if not char then return false end
    local h=char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed<25 then return true end
    local ok,val=pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val==true then return true end
    local ok2,val2=pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2==true then return true end
    for _,t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then return true end
        end
    end
    return false
end
function applyNoCamCollision()
    local enabled=(Dragon.tpBat and Dragon.tpBatNoCamCollision) or (not Dragon.tpBat and noCamCollisionEnabled)
    pcall(function()
        LP.DevCameraOcclusionMode=enabled and Enum.DevCameraOcclusionMode.Invisicam or Enum.DevCameraOcclusionMode.Zoom
    end)
end
-- Ambitious Soft auto-carry scan: nearest AnimalPodium spawn, excluding the
-- local player's own plot, replaces SNOW's broad "when near" check.
function snowAmbitiousSoftCarryNear()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local plots=workspace:FindFirstChild("Plots"); if not root or not plots then return false end
    local nearest=math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        local sign=plot:FindFirstChild("PlotSign",true); local own=sign and sign:GetAttribute("YourBase")==true
        if not own then
            local podiums=plot:FindFirstChild("AnimalPodiums")
            if podiums then for _,podium in ipairs(podiums:GetChildren()) do
                local spawn=(podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")) or podium:FindFirstChild("Spawn",true)
                if spawn and spawn:IsA("BasePart") then nearest=math.min(nearest,(root.Position-spawn.Position).Magnitude) end
            end end
        end
    end
    return nearest<=9.5
end

function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local shouldUseCarry=isStealState()
    if autoCarryMode=="WHEN_NEAR" then
        shouldUseCarry=snowAmbitiousSoftCarryNear() or (carrySpeedActive and isStealState())
    end
    if carrySpeedActive==shouldUseCarry then return end
    carrySpeedActive=shouldUseCarry
    _autoSwitchWasSteal=shouldUseCarry
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive) end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1); updateAutoSwitchSpeed() end end)

function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
function stopHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn=nil end
end

function setInfJumpInternal(enabled)
    infJumpEnabled=enabled==true
    stopHoldInfJump()
    if manualInfJumpConn then manualInfJumpConn:Disconnect(); manualInfJumpConn=nil end
    if not infJumpEnabled then return end
    if tostring(infJumpMode):lower()=="hold" then
        startHoldInfJump()
    else
        manualInfJumpConn=UIS.JumpRequest:Connect(function()
            if not infJumpEnabled then return end
            local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local velocity=root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity=Vector3.new(velocity.X,50,velocity.Z)
            end
        end)
    end
end

instaResetBusy=false
instaResetCooldownUntil=0
instaResetAntiDieActive=false
instaResetAntiDieConn=nil
function setInstaResetAntiDie(on)
    instaResetAntiDieActive=on==true
    if instaResetAntiDieConn then pcall(function() instaResetAntiDieConn:Disconnect() end); instaResetAntiDieConn=nil end
    if not instaResetAntiDieActive then return end
    local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    instaResetAntiDieConn=hum.HealthChanged:Connect(function(health)
        if instaResetAntiDieActive and health<=0 then pcall(function() hum.Health=hum.MaxHealth end) end
    end)
end
function runInstaReset()
    if instaResetBusy or tick()<(instaResetCooldownUntil or 0) then return end
    instaResetBusy=true
    task.spawn(function()
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health<=0 then instaResetCooldownUntil=tick()+.8; instaResetBusy=false; return end
        local originalHipHeight=hum.HipHeight
        local originalCollision={}
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then originalCollision[part]=part.CanCollide end
        end
        local resetSuccessful=false
        local attempts=0
        while char and char.Parent and hum and hum.Parent and hum.Health>0 and LP.Character==char and attempts<40 do
            pcall(function()
                hum.HipHeight=1e30
                hum.AutoRotate=true
                for part,_ in pairs(originalCollision) do
                    if part and part.Parent then part.CanCollide=false end
                end
            end)
            task.wait(.05)
            if LP.Character~=char or not char.Parent or not hum.Parent or hum.Health<=0 then
                resetSuccessful=true
                break
            end
            attempts=attempts+1
        end
        -- If the hip-height reset did not transition the character, use the
        -- normal health reset fallback once rather than leaving it altered.
        if not resetSuccessful and char and char.Parent and hum and hum.Parent and hum.Health>0 and LP.Character==char then
            pcall(function() hum.Health=0 end)
            task.wait(.1)
            resetSuccessful=(LP.Character~=char or not char.Parent or not hum.Parent or hum.Health<=0)
        end
        if not resetSuccessful and char and char.Parent and hum and hum.Parent then
            pcall(function()
                hum.HipHeight=originalHipHeight
                for part,canCollide in pairs(originalCollision) do
                    if part and part.Parent then part.CanCollide=canCollide end
                end
            end)
        end
        setInstaResetAntiDie(false)
        instaResetCooldownUntil=tick()+.8
        instaResetBusy=false
    end)
end

KB={
    DropBrainrot={kb=Enum.KeyCode.H,gp=nil},
    AutoLeft={kb=Enum.KeyCode.J,gp=nil},
    AutoRight={kb=Enum.KeyCode.L,gp=nil},
    AutoPlay={kb=Enum.KeyCode.Z,gp=nil},
    AutoBat={kb=Enum.KeyCode.E,gp=nil},
    TPBat={kb=Enum.KeyCode.Y,gp=nil},
    TPFloor={kb=Enum.KeyCode.T,gp=nil},
    GuiHide={kb=Enum.KeyCode.RightControl,gp=nil},
    -- Keep the advertised/default speed shortcut in the live bind table.  Q
    -- used to be handled by a separate legacy path whose action was empty,
    -- so it looked bound but never did anything.
    SpeedToggle={kb=Enum.KeyCode.Q,gp=nil},
    LaggerToggle={kb=Enum.KeyCode.K,gp=nil},
    InstaReset={kb=Enum.KeyCode.R,gp=nil},
}
AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
-- Final facing directions from Snow's two-step AutoPlay route.
AP_LFACE,AP_RFACE=Vector3.new(-482.25,-4.96,92.09),Vector3.new(-482.06,-6.93,35.47)
Steal={
    AutoStealEnabled=false,
    RagdollSteal=false,
    RagdollStealPauseSeconds=1.3,
    StealRadius=60,
    StealDuration=1.3,
    Mode=1, -- Normal V1 stop choice (90/85/80/70; never 75)
    Data={},
}
holdAtEnabled=false
snowStealRadii=snowStealRadii or {Normal=60}
STEAL_TRYHARD_DISTANCE=10
STEAL_MODE_CFG = {
    [1] = { threshold = 0.90, nearDist = 14 },
    [2] = { threshold = 0.85, nearDist = 12 },
    [3] = { threshold = 0.80, nearDist = 11 },
    [4] = { threshold = 0.70, nearDist = 10 },
}
isStealing,stealStartTime=false,nil
stealVisualPct=0
Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
MEDUSA_COOLDOWN=8; batCounterDebounce=false
modeValLbl=nil; lastMoveDir=Vector3.new(0,0,0)
MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

function isRagdollState(hum)
    if not hum then return true end; local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
-- A wall can put the character into Physics/FallingDown too. Record an
-- actual contact with another player's bat and only treat that as a hit.
snowBatHitConn=nil
snowLastBatHitAt=0
local function snowIsBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name=tool.Name:lower()
    return name:find("bat",1,true) or name:find("slap",1,true)
end
function snowTrackBatContact(char)
    if snowBatHitConn then snowBatHitConn:Disconnect(); snowBatHitConn=nil end
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    snowBatHitConn=root.Touched:Connect(function(part)
        local tool=part and part:FindFirstAncestorOfClass("Tool")
        local ownerModel=part and part:FindFirstAncestorOfClass("Model")
        local owner=ownerModel and Players:GetPlayerFromCharacter(ownerModel)
        if owner and owner~=LP and snowIsBatTool(tool) then snowLastBatHitAt=tick() end
    end)
end
function snowWasHitByBat(char)
    if tick()-snowLastBatHitAt<=1.15 then return true end
    -- Some games do not replicate a Tool Handle touch to the victim. In that
    -- case, accept only a very close player currently wielding a bat/slap.
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _,other in ipairs(Players:GetPlayers()) do
        local otherChar=other~=LP and other.Character
        local otherRoot=otherChar and otherChar:FindFirstChild("HumanoidRootPart")
        if otherRoot and (otherRoot.Position-root.Position).Magnitude<=12 then
            for _,child in ipairs(otherChar:GetChildren()) do
                if snowIsBatTool(child) then return true end
            end
        end
    end
    return false
end
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot=plots:FindFirstChild(plotName); if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
function isNearPodiumWithPrompt()
    local char=LP.Character; local hrpL=char and char:FindFirstChild("HumanoidRootPart"); if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base"); if not base then continue end
            local sp=base:FindFirstChild("Spawn"); if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude; if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment"); if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end
function getStealHRP()
    local c=LP.Character
    if c then
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    end
    return nil
end
function getPromptPosition(prompt)
    local att=prompt:FindFirstChild("Attachment")
    if att then return att.WorldPosition or att.Position end
    local parent=prompt.Parent
    if parent and parent:IsA("BasePart") then return parent.Position end
    if parent and parent.Parent and parent.Parent:IsA("BasePart") then return parent.Parent.Position end
    if parent and parent.Parent and parent.Parent.Parent and parent.Parent.Parent:IsA("BasePart") then
        return parent.Parent.Parent.Position
    end
    -- fallback: spawn under podium
    local p=parent
    while p and p~=workspace do
        if p.Name=="Spawn" and p:IsA("BasePart") then return p.Position end
        p=p.Parent
    end
    return nil
end
function findNearestPrompt()
    local hrp=getStealHRP()
    if not hrp then return nil end
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base")
            if not base then continue end
            local spawn=base:FindFirstChild("Spawn")
            if not spawn then continue end
            local d=(spawn.Position-hrp.Position).Magnitude
            if d<=Steal.StealRadius and d<dist then
                local att=spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _,p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then
                            nearest,dist=p,d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
function executeSteal(prompt)
    if isStealing or not Steal.AutoStealEnabled then return end
    if not prompt or not prompt.Parent then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end
            end
            for _,c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end
            end
        end
    end
    local data=Steal.Data[prompt]
    if not data.ready then return end
    data.ready=false
    isStealing=true
    stealStartTime=tick()
    stealVisualPct=0
    task.spawn(function()
        -- Original Dragon Normal callbacks and timing; Semi paths are removed.
        for _,f in ipairs(data.hold) do pcall(f) end
    end)
    local cfg=STEAL_MODE_CFG[Steal.Mode] or STEAL_MODE_CFG[1]
    local threshold=holdAtEnabled and cfg.threshold or 1
    local nearDist=holdAtEnabled and 6 or math.huge
    local totalTime=tonumber(Steal.StealDuration) or 1.3
    local timeToThreshold=totalTime*threshold
    local timeAfterThreshold=totalTime-timeToThreshold
    local startTime=tick()
    while tick()-startTime<timeToThreshold do
        if not Steal.AutoStealEnabled then isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0; return end
        stealVisualPct=math.clamp((tick()-startTime)/totalTime,0,threshold)
        task.wait()
    end
    stealVisualPct=threshold
    local hrp=getStealHRP(); local stillNear=false
    if hrp then
        local targetPos=getPromptPosition(prompt)
        if targetPos and (targetPos-hrp.Position).Magnitude<=nearDist then stillNear=true end
    end
    if not stillNear then
        local holdStart=tick()
        while tick()-holdStart<4 do
            if not Steal.AutoStealEnabled then isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0; return end
            stealVisualPct=threshold
            local root=getStealHRP(); local targetPos=getPromptPosition(prompt)
            if root and targetPos and (targetPos-root.Position).Magnitude<=nearDist then stillNear=true; break end
            task.wait()
        end
        if not stillNear then isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0; return end
    end
    local resumeTime=tick()
    while tick()-resumeTime<timeAfterThreshold do
        if not Steal.AutoStealEnabled then isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0; return end
        stealVisualPct=threshold+(tick()-resumeTime)/math.max(timeAfterThreshold,0.01)*(1-threshold)
        task.wait()
    end
    stealVisualPct=1
    for _,f in ipairs(data.trigger) do pcall(f) end
    task.wait(0.05)
    data.ready=true; isStealing=false; stealStartTime=nil; stealVisualPct=0
end
function onAutoPathFinished() end -- kept for path hooks; new system handles near-check itself
startAutoSteal=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled then return end
        -- K7's Stop When Hit logic, exposed in Snow as Ragdoll Steal.
        -- A new ragdoll starts one timed pause; standing up does not cancel it.
        if Steal.RagdollSteal then
            local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if isRagdollState(hum) or tick()<(Dragon.cleanRagdollDetectedUntil or 0) then
                if not Steal.ragdollWasDown then
                    Steal.ragdollWasDown=true
                    local pauseSeconds=math.clamp(tonumber(Steal.RagdollStealPauseSeconds) or 1.3,.1,30)
                    Steal.ragdollPauseToken=(Steal.ragdollPauseToken or 0)+1
                    local pauseToken=Steal.ragdollPauseToken
                    -- Stop the current steal immediately instead of allowing its
                    -- progress bar to finish after the player gets ragdolled.
                    -- Pause the worker only. Keep the setting enabled so the
                    -- Auto Steal toggle cannot turn itself off on ragdoll.
                    stopAutoSteal()
                    task.delay(pauseSeconds,function()
                        if Steal.ragdollPauseToken==pauseToken and Steal.RagdollSteal and Steal.AutoStealEnabled then
                            startAutoSteal()
                        end
                    end)
                end
                return
            end
            Steal.ragdollWasDown=false
        end
        if isStealing then return end
        local success,prompt=pcall(findNearestPrompt)
        if success and prompt then
            pcall(executeSteal,prompt)
        end
    end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
    isStealing=false
    stealStartTime=nil
    stealVisualPct=0
end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

-- speed handled by Anti Drop system (getActiveMoveSpeed + _snowApplyVelocitySpeed)


LP.CharacterAdded:Connect(function(char)
    task.wait(0.5); setupSpeedIndicator(char); setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5); startUnwalk() end
    if animPackName and animPackName~="OFF" then
        task.delay(0.4,function() pcall(function() applyAnimPack(animPackName) end) end)
    end
    task.delay(0.5, function() pcall(function() applyCharterToChar(char) end) end)
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    -- Re-apply ESP for spawned char
    if espEnabled then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                task.spawn(function()
                    task.wait(0.4)
                    if espEnabled then espMakeLabel(plr) end
                end)
            end
        end
    end
end)
if LP.Character then setupSpeedIndicator(LP.Character); setupRagdollTriggers(); task.spawn(function() task.wait(0.6); pcall(applyCharterToChar, LP.Character) end) end

alConn,arConn=nil,nil; alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
    snowAutoLeftWallGuard.normal=nil; snowAutoLeftWallGuard.untilTime=0
    local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
    snowAutoRightWallGuard.normal=nil; snowAutoRightWallGuard.untilTime=0
    local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

function findBat()
    local char=LP.Character; if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack"); if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

startAutoLeft=function()
    if Dragon.clearExclusive then Dragon.clearExclusive("AUTO_LEFT") end
    if alConn then alConn:Disconnect() end; alPhase=1
    snowAutoLeftWallGuard.normal=nil; snowAutoLeftWallGuard.untilTime=0
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if dragonAutoPathMove(hrp,hum,tgt,spd) then alPhase=2 end
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if dragonAutoPathMove(hrp,hum,tgt,spd) then
                hum:Move(Vector3.zero,false); snowClearVelocity()
                autoLeftEnabled=false; if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                if AP_LFACE and (AP_LFACE-hrp.Position).Magnitude>0.01 then
                    hrp.CFrame=CFrame.new(hrp.Position,Vector3.new(AP_LFACE.X,hrp.Position.Y,AP_LFACE.Z))
                end
                pcall(saveConfig)
                if onAutoPathFinished then onAutoPathFinished() end
                return
            end
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end
startAutoRight=function()
    if Dragon.clearExclusive then Dragon.clearExclusive("AUTO_RIGHT") end
    if arConn then arConn:Disconnect() end; arPhase=1
    snowAutoRightWallGuard.normal=nil; snowAutoRightWallGuard.untilTime=0
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if dragonAutoPathMove(hrp,hum,tgt,spd) then arPhase=2 end
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if dragonAutoPathMove(hrp,hum,tgt,spd) then
                hum:Move(Vector3.zero,false); snowClearVelocity()
                autoRightEnabled=false; if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                if AP_RFACE and (AP_RFACE-hrp.Position).Magnitude>0.01 then
                    hrp.CFrame=CFrame.new(hrp.Position,Vector3.new(AP_RFACE.X,hrp.Position.Y,AP_RFACE.Z))
                end
                pcall(saveConfig)
                if onAutoPathFinished then onAutoPathFinished() end
                return
            end
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
_wfConns={}
local function runStandDrop()
    if dropActive then return end
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    autoAfterDropWasCarrying=autoAfterDropEnabled and hum.WalkSpeed<25
    dropActive=true
    local started=tick()
    task.spawn(function()
        while dropActive and tick()-started<.25 do
            RunService.Heartbeat:Wait()
            local current=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not current then break end
            local velocity=current.AssemblyLinearVelocity
            velocity=Vector3.new(0,velocity.Y,0)
            current.AssemblyLinearVelocity=velocity*10000+Vector3.new(0,10000,0)
            RunService.RenderStepped:Wait()
            if current.Parent then current.AssemblyLinearVelocity=velocity end
            RunService.Stepped:Wait()
            if current.Parent then current.AssemblyLinearVelocity=velocity+Vector3.new(0,.1,0) end
        end
        local current=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local currentHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if current then
            current.AssemblyLinearVelocity=Vector3.zero; current.AssemblyAngularVelocity=Vector3.zero
            local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances={LP.Character}
            local ground=workspace:Raycast(current.Position,Vector3.new(0,-2000,0),params)
            if ground then current.CFrame=CFrame.new(current.Position.X,ground.Position.Y+(currentHum and currentHum.HipHeight or 2)+current.Size.Y/2,current.Position.Z) end
        end
        if currentHum and currentHum.Health>0 then currentHum:ChangeState(Enum.HumanoidStateType.Running) end
        dropActive=false
        if runAutoAfterDrop then runAutoAfterDrop() end
    end)
end
-- Drop system from VYNX (ascend then snap to ground)
function runDrop()
    if dropActive then return end
    if dropBrainrotMode=="STAND" then runStandDrop(); return end
    -- stop conflicting combat modes
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if stopBatAimbot then stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); autoAfterDropWasCarrying=autoAfterDropEnabled and hum and hum.WalkSpeed<25 or false
    dropActive=true
    local t0=tick()
    local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if dc then dc:Disconnect() end
            dropActive=false
            return
        end
        if tick()-t0 >= (DROP_ASCEND_DURATION or 0.2) then
            dc:Disconnect()
            local rp=RaycastParams.new()
            rp.FilterDescendantsInstances={char}
            rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position, Vector3.new(0,-2000,0), rp)
            if rr then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X, rr.Position.Y+off, r.Position.Z)
                pcall(function()
                    r.AssemblyLinearVelocity=Vector3.zero
                    r.Velocity=Vector3.zero
                end)
            end
            dropActive=false
            if runAutoAfterDrop then runAutoAfterDrop() end
            return
        end
        -- ascend
        pcall(function()
            r.Velocity=Vector3.new(r.Velocity.X, DROP_ASCEND_SPEED or 150, r.Velocity.Z)
            r.AssemblyLinearVelocity=Vector3.new(
                r.AssemblyLinearVelocity.X,
                DROP_ASCEND_SPEED or 150,
                r.AssemblyLinearVelocity.Z
            )
        end)
    end)
end

-- Ambitious ground resolver: ignores characters/non-collidable geometry and
-- lands on the real walkable surface, with the original -7 void fallback.
function snowResolveTPDownY(char,root,hum)
    local filter={char}
    for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP and plr.Character then table.insert(filter,plr.Character) end end
    local filterType=Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
    local half=root.Size.Y*.5; local offset=half+(hum.HipHeight or half*2)
    if offset~=offset or offset<1 or offset>12 then offset=half*3 end
    local fromY=root.Position.Y-half-.1
    for _=1,12 do
        local params=RaycastParams.new(); params.FilterDescendantsInstances=filter; params.FilterType=filterType; params.IgnoreWater=true; pcall(function() params.RespectCanCollide=true end)
        local result=workspace:Raycast(Vector3.new(root.Position.X,fromY,root.Position.Z),Vector3.new(0,-4000,0),params)
        if not result then break end
        local part=result.Instance; local skip=not part or (part:IsA("BasePart") and not part.CanCollide)
        local model=part and part:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") then skip=true end
        if not skip then return result.Position.Y+offset+.15 end
        table.insert(filter,part); fromY=result.Position.Y-.05
    end
    return -7
end

-- Port of Ambitious TP Down behavior, adapted to SNOW's APIs.
function snowSlowFallDown(targetY,zigzag)
    if tpDownSlowFallActive then return end
    tpDownSlowFallActive=true
    tpDownJumpLocked=true
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    local lateral=Vector3.zero
    if zigzag and root then
        tpDownZigZagSide=-tpDownZigZagSide
        local right=root.CFrame.RightVector; local flat=Vector3.new(right.X,0,right.Z)
        if flat.Magnitude>.001 then lateral=flat.Unit*(tonumber(getActiveMoveSpeed and getActiveMoveSpeed()) or NS or 16)*tpDownZigZagSide end
    end
    task.spawn(function()
        local deadline=os.clock()+6; local power=zigzag and 50 or 115; local landed=false
        while os.clock()<deadline do
            local c=LP.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
            if not r or not h or h.Health<=0 then break end
            if h.FloorMaterial~=Enum.Material.Air then landed=true; break end
            local v=r.AssemblyLinearVelocity
            r.AssemblyLinearVelocity=Vector3.new(zigzag and lateral.X or v.X,-power,zigzag and lateral.Z or v.Z)
            RunService.Heartbeat:Wait()
        end
        tpDownSlowFallActive=false
        -- Ambitious keeps the jump lock until actual ground contact, so held
        -- Infinite Jump cannot overwrite the downward velocity mid-fall.
        local groundDeadline=os.clock()+8
        while os.clock()<groundDeadline do
            local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if not h or h.Health<=0 or h.FloorMaterial~=Enum.Material.Air then break end
            RunService.Heartbeat:Wait()
        end
        tpDownJumpLocked=false
    end)
end

function doAutoTPDown(force)
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end; if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.Velocity=Vector3.zero
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn=nil end
    autoTPConn=task.spawn(function()
        while autoTPEnabled do task.wait(0.1); pcall(function() doAutoTPDown(false) end) end
    end)
end
stopAutoTP=function()
    autoTPEnabled=false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn=nil end
end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end

SNOW_STRETCH_NAME="Snow_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true; if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(SNOW_STRETCH_NAME) end)
    pcall(function()
        RunService:BindToRenderStep(SNOW_STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function()
            local cam=workspace.CurrentCamera
            local y=stretchRezScale==4 and .32 or (stretchRezScale==3 and .45 or .65)
            if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,y,0,0,0,1) end
        end)
    end)
end
disableStretchRez=function()
    stretchRezEnabled=false; pcall(function() RunService:UnbindFromRenderStep(SNOW_STRETCH_NAME) end)
end

defLightBrightness,defLightClock,defLightAmbient,defLightShadows,defLightFogEnd,defLightDiffuse,defLightSpecular = nil,nil,nil,nil,nil,nil,nil
function applyAntiLagDerender(obj)
    pcall(function()
        -- Snow Anti Lag's object-cleanup rules, processed in batches
        -- to avoid a freeze while the existing map is scanned.
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            -- Hide cosmetic geometry without destroying tools/accessories.
            for _,part in ipairs(obj:GetDescendants()) do if part:IsA("BasePart") then part.LocalTransparencyModifier=1; part.CastShadow=false end end
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic; obj.Reflectance=0; obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
local function queueAntiLagObject(obj)
    if not antiLagEnabled or not obj or antiLagQueued[obj] then return end
    antiLagQueued[obj]=true
    table.insert(antiLagQueue,obj)
end
local function startAntiLagWorker()
    if antiLagWorker then return end
    antiLagWorker=task.spawn(function()
        while antiLagEnabled do
            -- Process a bounded batch per frame so enabling Anti Lag cannot
            -- freeze the client on worlds with many map descendants.
            for _=1,280 do
                local obj=antiLagQueue[antiLagQueueHead]
                antiLagQueue[antiLagQueueHead]=nil
                antiLagQueueHead=antiLagQueueHead+1
                if not obj then break end
                antiLagQueued[obj]=nil
                if obj.Parent then applyAntiLagDerender(obj) end
            end
            task.wait()
        end
        antiLagWorker=nil
        table.clear(antiLagQueue); antiLagQueueHead=1; table.clear(antiLagQueued)
    end)
end
enableAntiLag=function()
    -- Config is read before this worker is created, therefore the boolean
    -- alone cannot tell us whether Anti Lag is already running.
    if antiLagEnabled and antiLagDescConn then return end
    removeAccessoriesEnabled=true; antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness
    defLightClock=defLightClock or Lighting.ClockTime
    defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    defLightShadows=defLightShadows==nil and Lighting.GlobalShadows or defLightShadows
    defLightFogEnd=defLightFogEnd or Lighting.FogEnd
    defLightDiffuse=defLightDiffuse==nil and Lighting.EnvironmentDiffuseScale or defLightDiffuse
    defLightSpecular=defLightSpecular==nil and Lighting.EnvironmentSpecularScale or defLightSpecular
    Lighting.GlobalShadows=false; Lighting.FogEnd=1e10
    Lighting.EnvironmentDiffuseScale=0; Lighting.EnvironmentSpecularScale=0
    pcall(function()
        local terrain=workspace:FindFirstChildOfClass("Terrain")
        if terrain then antiLagTerrainDecoration=terrain.Decoration; terrain.Decoration=false end
    end)
    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                antiLagEffectState[e]=e.Enabled
                e.Enabled=false
            end
        end)
    end
    for _,obj in ipairs(workspace:GetDescendants()) do queueAntiLagObject(obj) end
    startAntiLagWorker()
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then queueAntiLagObject(obj) end
    end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false; antiLagEnabled=false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn=nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness=defLightBrightness end
        if defLightClock then Lighting.ClockTime=defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end
        if defLightShadows~=nil then Lighting.GlobalShadows=defLightShadows end
        if defLightFogEnd then Lighting.FogEnd=defLightFogEnd end
        if defLightDiffuse~=nil then Lighting.EnvironmentDiffuseScale=defLightDiffuse end
        if defLightSpecular~=nil then Lighting.EnvironmentSpecularScale=defLightSpecular end
        Lighting.ExposureCompensation=0
        local terrain=workspace:FindFirstChildOfClass("Terrain")
        if terrain and antiLagTerrainDecoration~=nil then terrain.Decoration=antiLagTerrainDecoration end
    end)
    for effect,wasEnabled in pairs(antiLagEffectState) do if effect and effect.Parent then pcall(function() effect.Enabled=wasEnabled end) end end
    table.clear(antiLagEffectState)
end

enableFPSBoost=function()
    fpsBoostEnabled=true
    table.clear(snowVisualUpdateClock)
end
disableFPSBoost=function()
    if not fpsBoostEnabled then return end
    fpsBoostEnabled=false
    table.clear(snowVisualUpdateClock)
end

-- ============================================================
-- ANIMATION PACKS (from Empire)
-- ============================================================
function stopAnimTracks(hum)
    if not hum then return end
    for _,tr in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
end
function setAnimId(obj,id)
    if obj and id then pcall(function() obj.AnimationId="rbxassetid://"..tostring(id) end) end
end
function saveOriginalAnims(char)
    local animate=char and char:FindFirstChild("Animate")
    if not animate or next(_animOriginalIds) then return end
    local function gid(folder,child)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        return a and a.AnimationId or nil
    end
    _animOriginalIds={
        walk=gid("walk","WalkAnim"), run=gid("run","RunAnim"),
        jump=gid("jump","JumpAnim"), fall=gid("fall","FallAnim"),
        climb=gid("climb","ClimbAnim"), swim=gid("swim","Swim"), swimidle=gid("swimidle","SwimIdle"),
        idle1=gid("idle","Animation1"), idle2=gid("idle","Animation2"), idle3=gid("idle","Animation3"),
    }
end
function resetAnimPack(char)
    char=char or LP.Character
    local animate=char and char:FindFirstChild("Animate")
    if not animate or not next(_animOriginalIds) then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function apply(folder,child,key)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        if a and _animOriginalIds[key] then a.AnimationId=_animOriginalIds[key] end
    end
    apply("walk","WalkAnim","walk"); apply("run","RunAnim","run")
    apply("jump","JumpAnim","jump"); apply("fall","FallAnim","fall")
    apply("climb","ClimbAnim","climb"); apply("swim","Swim","swim"); apply("swimidle","SwimIdle","swimidle")
    apply("idle","Animation1","idle1"); apply("idle","Animation2","idle2"); apply("idle","Animation3","idle3")
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
end
function applyAnimPack(packName)
    animPackName=packName or "OFF"
    local char=LP.Character
    if not char then return false end
    if packName=="OFF" or not ANIM_PACKS[packName] then
        resetAnimPack(char)
        return false
    end
    local pack=ANIM_PACKS[packName]
    saveOriginalAnims(char)
    local animate=char:FindFirstChild("Animate")
    if not animate then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function ensure(folderName,animName)
        local folder=animate:FindFirstChild(folderName)
        if not folder then return nil end
        local a=folder:FindFirstChild(animName)
        if not a then
            a=Instance.new("Animation"); a.Name=animName; a.Parent=folder
        end
        return a
    end
    -- M changer accepts both naming formats: WalkAnim/RunAnim and Walk/Run.
    local function pick(...)
        for i=1,select("#",...) do local v=pack[select(i,...)] if v~=nil then return v end end
    end
    setAnimId(ensure("walk","WalkAnim"),pick("WalkAnim","Walk"))
    setAnimId(ensure("run","RunAnim"),pick("RunAnim","Run"))
    setAnimId(ensure("jump","JumpAnim"),pick("JumpAnim","Jump"))
    setAnimId(ensure("fall","FallAnim"),pick("FallAnim","Fall"))
    setAnimId(ensure("climb","ClimbAnim"),pick("ClimbAnim","Climb"))
    setAnimId(ensure("swim","Swim"),pick("Swim"))
    setAnimId(ensure("swimidle","SwimIdle"),pick("SwimIdle","Swim"))
    local a1,a2=pick("Animation1"),pick("Animation2")
    if a1 or a2 then
        setAnimId(ensure("idle","Animation1"),a1 or a2)
        setAnimId(ensure("idle","Animation2"),a2 or a1)
    elseif pack.Idle and #pack.Idle>0 then
        for i,id in ipairs(pack.Idle) do setAnimId(ensure("idle","Animation"..i),id) end
        setAnimId(ensure("idle","Animation2"),pack.Idle[2] or pack.Idle[1])
    end
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
    return true
end

function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
    end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end
    if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character; if not c then return end
    medusaDebounce=true
    local med=findMedusa()
    if not med then medusaDebounce=false; return end
    local hum2=c:FindFirstChildOfClass("Humanoid")
    if med.Parent~=c and hum2 then
        pcall(function() hum2:EquipTool(med) end)
        -- Equip replication takes a frame; firing in the same frame is what
        -- made Medusa get consumed before it could reach the opponent.
        task.wait(.08)
    end
    if med.Parent~=c then medusaDebounce=false; return end
    pcall(function() med:Activate() end)
    pcall(function()
        local rem=med:FindFirstChildWhichIsA("RemoteEvent",true)
        if rem then rem:FireServer() end
    end)
    medusaLastUsed=tick()
    -- Leave Medusa equipped for its cast window, then return to the bat so
    -- the aimbot can continue normally instead of trying to swing Medusa.
    task.delay(.65,function()
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        local bat=dragonFindBat and dragonFindBat()
        if hum and bat and bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
    end)
    task.defer(function() medusaDebounce=false end)
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and (part.Transparency>=0.9 or part.LocalTransparencyModifier>=0.9) then
            if medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
    -- fast Heartbeat scan (catches TP/stone without relying only on property signal)
    table.insert(Conns.anchor, RunService.Heartbeat:Connect(function()
        if not medusaCounterEnabled or medusaDebounce then return end
        if not char or not char.Parent then return end
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Anchored and (part.Transparency>=0.9 or part.Name=="HumanoidRootPart") then
                -- stone/ragdoll style lock often anchors HRP or makes parts invisible
                if part.Transparency>=0.9 then
                    useMedusaCounter()
                    return
                end
            end
        end
    end))
end
stopMedusaCounter=function()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={}
end

-- ============================================================
-- SAFE MODE (from SenpaiHub) — locks combat paths while carrying / duel countdown
-- ============================================================
SafeMode = {
    blockedTools = {
        bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
        medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
    },
    monitorStarted = false,
}

function SafeMode.getCountdownLabel()
    local ok, label = pcall(function()
        return LP.PlayerGui
            and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function SafeMode.countdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function SafeMode.inDuelCountdown()
    local label = SafeMode.getCountdownLabel()
    return label and SafeMode.countdownNumber(label.Text) or false
end

function SafeMode.isCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(SafeMode.blockedTools) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function SafeMode.holdingBrainrot()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = LP.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                return true
            end
            -- non-weapon tools often = carried animal
            if SafeMode.isCarryableTool(child) and (n:find("animal") or n:find("pet") or n:find("rot") or #n > 2) then
                -- only treat as carry if not a known combat tool (already filtered)
                if not (n:find("bat") or n:find("slap") or n:find("medusa")) then
                    -- soft check: many brainrot tools are unique names
                end
            end
        end
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    -- backpack-equipped brainrot style tools on character only (already checked tools above)
    return false
end

function SafeMode.isLocked()
    if not Dragon.antiKick then return false end
    return SafeMode.inDuelCountdown() or SafeMode.holdingBrainrot()
end

function SafeMode.forceStop(reason)
    local stopped = false
    if autoBatEnabled then
        autoBatEnabled = false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if stopBatAimbot then stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        stopped = true
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if stopAutoLeft then stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
        stopped = true
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if stopAutoRight then stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
        stopped = true
    end
    if Dragon.tpBat then
        if Dragon.stopTPBat then Dragon.stopTPBat() end
        if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
        stopped = true
    end
    Dragon.brainrot = SafeMode.holdingBrainrot()
    return stopped
end

function SafeMode.tryStart()
    if SafeMode.isLocked() then
        SafeMode.forceStop("SAFE MODE")
        return false
    end
    return true
end

function Dragon.enableAntiKick()
    Dragon.antiKick = true
    if not SafeMode.monitorStarted then
        SafeMode.monitorStarted = true
        RunService.Heartbeat:Connect(function()
            if Dragon.antiKick and SafeMode.isLocked() then
                SafeMode.forceStop("SAFE MODE")
            end
            -- keep legacy brainrot flag in sync for any old checks
            Dragon.brainrot = Dragon.antiKick and SafeMode.holdingBrainrot()
        end)
    end
    -- immediate lock check
    if SafeMode.isLocked() then
        SafeMode.forceStop("SAFE MODE")
    end
end

function Dragon.disableAntiKick()
    Dragon.antiKick = false
    Dragon.brainrot = false
end

-- SNOW BAT COUNTER V1
SnowBatCounterState = SnowBatCounterState or {}
SnowBatCounterState.batConn = nil
SnowBatCounterState.batDebounce = false
SnowBatCounterToolList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}

function SnowFindBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    for _, name in ipairs(SnowBatCounterToolList) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

function SnowSwingBatForCounter(bat, char)
    if not bat or not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum then pcall(function() hum:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

function SnowCounterIsRagdoll(hum)
    if not hum then return false end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
        or hum.PlatformStand == true
end

-- Ambitious Bat Counter V2 uses an enemy ragdoll time-lock.  It avoids
-- countering the ragdoll that our own hit has just caused.
SnowBatCounterState.enemyLock=SnowBatCounterState.enemyLock or {}
SnowBatCounterState.watchConns=SnowBatCounterState.watchConns or {}
function SnowCounterIsRagdollForBat(hum)
    if not hum then return false end
    local st=hum:GetState()
    return st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or hum.PlatformStand==true
end
function SnowStopBatCounterWatcher()
    for key,conn in pairs(SnowBatCounterState.watchConns) do pcall(function() conn:Disconnect() end); SnowBatCounterState.watchConns[key]=nil end
    table.clear(SnowBatCounterState.enemyLock)
end
function SnowStartBatCounterWatcher()
    SnowStopBatCounterWatcher()
    local conns=SnowBatCounterState.watchConns
    local function hookPlayer(plr)
        if plr==LP then return end
        local function hookChar(char)
            local key=tostring(plr.UserId).."_char"
            if conns[key] then pcall(function() conns[key]:Disconnect() end) end
            conns[key]=char.DescendantAdded:Connect(function(item)
                if item:IsA("BallSocketConstraint") then SnowBatCounterState.enemyLock[plr]=tick()+2.6 end
            end)
        end
        conns[tostring(plr.UserId).."_added"]=plr.CharacterAdded:Connect(hookChar)
        if plr.Character then hookChar(plr.Character) end
    end
    conns.playerAdded=Players.PlayerAdded:Connect(hookPlayer)
    conns.playerRemoving=Players.PlayerRemoving:Connect(function(plr) SnowBatCounterState.enemyLock[plr]=nil end)
    for _,plr in ipairs(Players:GetPlayers()) do hookPlayer(plr) end
end
function SnowNearestCounterEnemy()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local best,bestDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        local char=plr~=LP and plr.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health>0 then local dist=(hrp.Position-root.Position).Magnitude; if dist<bestDist then best,bestDist=plr,dist end end
    end
    return best
end

function SnowStartBatCounter()
    if SnowBatCounterState.batConn then return end
    SnowBatCounterState.batDebounce = false
    SnowStartBatCounterWatcher()
    SnowBatCounterState.batConn = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or SnowBatCounterState.batDebounce then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 or not SnowCounterIsRagdollForBat(hum) then return end
        SnowBatCounterState.batDebounce = true
        task.spawn(function()
            if batCounterMode=="V2" then
                local enemy=SnowNearestCounterEnemy()
                if enemy and (SnowBatCounterState.enemyLock[enemy] or 0)>tick() then
                    repeat task.wait(.1) until not SnowCounterIsRagdollForBat((LP.Character or char):FindFirstChildOfClass("Humanoid"))
                    SnowBatCounterState.batDebounce=false
                    return
                end
                task.wait(.05)
                local root=char:FindFirstChild("HumanoidRootPart"); local savedCF=root and root.CFrame
                local wasTPBat=Dragon.tpBat==true; Dragon.batCounterV2On=true
                if not wasTPBat then Dragon.startTPBat() end
                local bat=SnowFindBatForCounter(); if bat then task.spawn(function() SnowSwingBatForCounter(bat,char) end) end
                local snap=RunService.Heartbeat:Connect(function()
                    local plr=SnowNearestCounterEnemy(); local target=plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart"); local me=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if me and target then pcall(function() me.CFrame=CFrame.new(target.Position+Vector3.new(0,.9,0)); me.AssemblyLinearVelocity=Vector3.zero; me.AssemblyAngularVelocity=Vector3.zero end) end
                end)
                task.wait(.4); pcall(function() snap:Disconnect() end); Dragon.batCounterV2On=false
                if not wasTPBat then Dragon.stopTPBat() end
                local back=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if back and savedCF then pcall(function() back.CFrame=savedCF; back.AssemblyLinearVelocity=Vector3.zero end) end
            else
                local wasLocked=Dragon.bodyLock; local savedRange=Dragon.bodyLockRange
                Dragon.bodyLockRange=math.huge; Dragon.setBodyLock(true)
                local bat=SnowFindBatForCounter(); if bat then task.spawn(function() SnowSwingBatForCounter(bat,char) end) end
                task.wait(.7)
                Dragon.bodyLockRange=savedRange; Dragon.setBodyLock(wasLocked)
            end
            task.wait(0.5)
            SnowBatCounterState.batDebounce = false
        end)
    end)
end

function SnowStopBatCounter()
    if SnowBatCounterState.batConn then
        SnowBatCounterState.batConn:Disconnect()
        SnowBatCounterState.batConn = nil
    end
    SnowBatCounterState.batDebounce = false
    Dragon.batCounterV2On=false
    SnowStopBatCounterWatcher()
end

startBatCounter = SnowStartBatCounter
stopBatCounter = SnowStopBatCounter

-- BAT AIMBOT (old SNOW.VS system)
aimbotConn=nil
_predBall=nil
function getClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart"); local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist; closest=tRoot end
            end
        end
    end
    return closest
end
function swingCurrentBat()
    if not autoSwingEnabled then return end
    local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end
startBatAimbot=function()
    -- clear TP Bat so aimbot can run
    if Dragon.stopTPBat then Dragon.stopTPBat() else Dragon.tpBat=false end
    if Dragon.setTPBatVisual then pcall(function() Dragon.setTPBatVisual(false) end) end
    if mobBtnRefs and mobBtnRefs.tpBat then pcall(function() mobBtnRefs.tpBat(false) end) end
    if aimbotConn then aimbotConn:Disconnect() end
    autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if not c:FindFirstChildOfClass("Tool") then
            local bat=findBat(); if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target=getClosestTarget()
        if not target then swingCurrentBat(); return end
        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position
        local predictPos=targetPos+targetVel*0.14+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude < 0.05 then
            flatDir = root.CFrame.LookVector
        else
            flatDir = flatDir.Unit
        end
        local chaseSpeed=58
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local speed3=targetVel.Magnitude
        local predictTime=math.clamp(speed3/150,0.05,0.2)
        local predictedPos=targetPos+targetVel*predictTime
        local toPredict=predictedPos-myPos
        if toPredict.Magnitude>0.1 then
            local goalCF=CFrame.lookAt(myPos,predictedPos)
            local curCF=root.CFrame
            local diffCF=curCF:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5)
            local tiltSpeed=42
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed))
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn=nil end; autoBatEnabled=false
    if _predBall then _predBall:Destroy(); _predBall=nil end
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
queueAutoBatStart=function()
    -- clear stuck TP bat so aimbot can start
    if Dragon.tpBat and not Dragon.tpConn then
        Dragon.tpBat=false
    end
    if Dragon.tpBat then
        if Dragon.stopTPBat then Dragon.stopTPBat() end
        if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    end
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
    if Dragon.antiKick and Dragon.brainrot then return end
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3; hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

saveConfig=function()
    local function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,speedSystem=speedSystem,titleIndex=titleIndex,dragonProfileAlternate=dragonProfileAlternate,mobileButtonVisibility=mobileButtonVisibility,autoPlayMode=autoPlayMode,autoPlayRouteMode=autoPlayRouteMode,dropBrainrotMode=dropBrainrotMode,autoAfterDropEnabled=autoAfterDropEnabled,autoAfterDropMode=autoAfterDropMode,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),
        autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpBatKey=ks(KB.TPBat),
        tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,holdAtEnabled=holdAtEnabled,antiRagdoll=antiRagdollEnabled,antiRagdollVersion=Dragon.antiRagdollVersion,
        batV2Speed=batV2Speed,batV2Enabled=batV2Enabled,aimbotMode=aimbotMode,aimbotNormalVersion=aimbotNormalVersion,aimbotBypassVersion=aimbotBypassVersion,aimbotSpeed=AIMBOT_SPEED,laggerAimbotSpeed=LAGGER_AIMBOT_SPEED,bypassAimbotSpeed=BYPASS_AIMBOT_SPEED,bypassLaggerAimbotSpeed=BYPASS_LAGGER_AIMBOT_SPEED,hitCircleEnabled=hitCircleEnabled,mirrorTPDownEnabled=mirrorTPDownEnabled,snowThemeName=snowThemeName,tpBatAntiDie=Dragon.tpBatAntiDie,tpBatAntiVoid=Dragon.tpBatAntiVoid,tpBatAutoDisableOnHit=Dragon.tpBatAutoDisableOnHit,tpBatFreeCamera=Dragon.tpBatFreeCamera,tpBatNoCamCollision=Dragon.tpBatNoCamCollision,forceHit=Dragon.forceHit,bodyLock=Dragon.bodyLock,bodyLockMode=Dragon.bodyLockMode,bodyLockRange=Dragon.bodyLockRange,enemyRagdollTimerEnabled=Dragon.enemyRagdollTimerEnabled,noCamCollisionEnabled=noCamCollisionEnabled,autoStealEnabled=Steal.AutoStealEnabled,ragdollSteal=Steal.RagdollSteal,ragdollStealPauseSeconds=Steal.RagdollStealPauseSeconds,stealMode=Steal.Mode,stealRadii=snowStealRadii,stealBarScale=stealBarScale,stealBarLocked=stealBarLocked,stealBarHidden=stealBarHidden,stealBarBackgroundUrl=stealBarBackgroundUrl,
        stealBarPosition=(function()
            local bar=stealBarFrame
            if bar and bar.Parent then
                return {xs=bar.Position.X.Scale,xo=bar.Position.X.Offset,ys=bar.Position.Y.Scale,yo=bar.Position.Y.Offset}
            end
            return stealBarPosition
        end)(),infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,
        medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,batCounterMode=batCounterMode,e01Alert=e01AlertEnabled,e01AlertScale=e01AlertScale,hidePingWarner=hidePingWarner,carrySpeedActive=carrySpeedActive,antiDieEnabled=antiDieEnabled,
        laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled,aimbotAfterHit=aimbotAfterHitEnabled,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,fpsBoostEnabled=fpsBoostEnabled,fpsCapValue=fpsCapValue,fpsCapEnabled=fpsCapEnabled,performanceProfile=DragonPerformanceProfile,
        stretchRez=stretchRezEnabled,stretchRezScale=stretchRezScale,autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,tpDownMethod=tpDownMethod,uiAutoFadeEnabled=uiAutoFadeEnabled,tabsPosition=tabsPosition,collapsedTabMode=collapsedTabMode,colorfulGraphicsEnabled=colorfulGraphicsEnabled,motionBlurEnabled=motionBlurEnabled,
        guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,logoCircleEnabled=logoCircleEnabled,
        mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,
        circleButtonsEnabled=circleButtonsEnabled,autoSwitchSpeed=autoSwitchSpeedEnabled,autoCarryMode=autoCarryMode,autoCarryStealRange=autoCarryStealRange,uiLocked=uiLocked,
        headlessEnabled=headlessEnabled,korbloxEnabled=korbloxEnabled,korbloxMode=korbloxMode,korbloxLastMode=korbloxLastMode,batSkinMode=batSkinMode,batSoundsEnabled=batSoundsEnabled,medusaSkinMode=medusaSkinMode,medusaSoundsEnabled=medusaSoundsEnabled,swordColorMode=swordColorMode,
        animPackEnabled=animPackEnabled,animPackName=animPackName,
        fovValue=fovValue,perButtonDrag=perButtonDragEnabled,skyTheme=SnowCurrentSkyTheme,
        antiKick=Dragon.antiKick,autoMoveSwing=autoMoveSwingEnabled,
        autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled,
        espEnabled=espEnabled,enemySpeedEnabled=enemySpeedEnabled,espBoxEnabled=espBoxEnabled,espLineEnabled=espLineEnabled,
        backgroundEnabled=backgroundEnabled,backgroundIndex=backgroundIndex,customGuiBackgroundUrl=customGuiBackgroundUrl,lastBackgroundUrl=snowLastBackgroundUrl,snowThemeBackgroundIndex=SnowThemeBackgroundIndex,snowUiThemeName=snowUiThemeName,introSkipEnabled=introSkipEnabled,introVersion=introVersion,introSongIndex=introSongIndex,introBackgroundIndex=introBackgroundIndex,
        guiPosition=(function()
            local outer=GuiRefs and GuiRefs.outer
            if not outer then return snowGuiPosition end
            return {xs=outer.Position.X.Scale,xo=outer.Position.X.Offset,ys=outer.Position.Y.Scale,yo=outer.Position.Y.Offset}
        end)(),
        guiScale=(GuiRefs and GuiRefs.outerScale and GuiRefs.outerScale.Scale) or snowGuiScale or 0.70,
        keys=(function()
            if not _GuiKeys then return {} end
            local t={}; for k,v in pairs(_GuiKeys) do if v and v.Name then t[k]=v.Name end end; return t
        end)(),
        keybinds=(function()
            local t={}
            for name,entry in pairs(KB) do
                if type(entry)=="table" then
                    t[name]={
                        kb = entry.kb and entry.kb.Name or nil,
                        gp = entry.gp and entry.gp.Name or nil,
                    }
                end
            end
            return t
        end)()
    }
    if writefile then pcall(function() writefile(Dragon_CONFIG_FILE,HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)

function resetAllSettings()
    local hadFPSBoost=fpsBoostEnabled
    NS=60; CS=30; LAGGER_SPEED=40; LAGGER_CARRY_SPEED=20; speedSystem="V2"; carrySpeedActive=false; laggerModeEnabled=false; antiDieEnabled=true
    autoSwitchSpeedEnabled=false; antiRagdollEnabled=false; infJumpEnabled=false; infJumpMode="manual"
    medusaCounterEnabled=false; batCounterEnabled=false; batCounterMode="V1"; unwalkEnabled=false; hidePingWarner=true
    Dragon.antiKick=true; aimbotNormalVersion="V1"; aimbotBypassVersion="V1"; SnowSetHitCircle(false); Dragon.tpBatAntiDie=true; Dragon.tpBatAntiVoid=false; Dragon.tpBatAutoDisableOnHit=false; Dragon.tpBatFreeCamera=false; Dragon.tpBatNoCamCollision=false; Dragon.forceHit=false; Dragon.setBodyLock(false); Dragon.bodyLockMode="PERM"; Dragon.bodyLockRange=60; Dragon.enemyRagdollTimerEnabled=false; Dragon.stopEnemyRagdollTimer(); Steal.RagdollSteal=false; Steal.RagdollStealPauseSeconds=1.3; noCamCollisionEnabled=false; if Dragon.stopTPBat then Dragon.stopTPBat() end; if Dragon.enableAntiKick then Dragon.enableAntiKick() end
    autoLeftEnabled=false; autoRightEnabled=false; autoBatEnabled=false; autoSwingEnabled=true; autoMoveSwingEnabled=false
    autoTPEnabled=false; autoTPHeight=20; stretchRezEnabled=false; autoAfterDropEnabled=false; autoAfterDropMode="AIMBOT"; autoPlayMode=false; autoPlayRouteMode="FULL"
    batSkinMode="NONE"; batSoundsEnabled=false; medusaSkinMode="NONE"; medusaSoundsEnabled=false
    Steal.AutoStealEnabled=false; Steal.StealRadius=60; Steal.StealDuration=1.3; snowStealRadii={Normal=60}
    guiTransparencyEnabled=false; mobileButtonsEnabled=true; mobileButtonsSize=80
    circleButtonsEnabled=false; uiLocked=false; mobileButtonsLocked=false; uiAutoFadeEnabled=false; fovValue=80; fovIndex=1; introVersion=1
    fpsCapValue=60; fpsCapEnabled=false; if DragonApplyFpsCap then DragonApplyFpsCap() end
    DragonPerformanceProfile="QUALITY"
    -- A settings reset must restore usable defaults, not erase every
    -- shortcut.  Erasing these entries made the UI show keybind buttons that
    -- could no longer trigger an action until each one was rebound manually.
    KB.DropBrainrot={kb=Enum.KeyCode.H,gp=nil}; KB.AutoLeft={kb=Enum.KeyCode.J,gp=nil}; KB.AutoRight={kb=Enum.KeyCode.L,gp=nil}
    KB.AutoPlay={kb=Enum.KeyCode.Z,gp=nil}; KB.AutoBat={kb=Enum.KeyCode.E,gp=nil}; KB.TPBat={kb=Enum.KeyCode.Y,gp=nil}; KB.TPFloor={kb=Enum.KeyCode.T,gp=nil}
    KB.GuiHide={kb=Enum.KeyCode.RightControl,gp=nil}; KB.SpeedToggle={kb=Enum.KeyCode.Q,gp=nil}; KB.LaggerToggle={kb=Enum.KeyCode.K,gp=nil}
    KB.InstaReset={kb=Enum.KeyCode.R,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot(); stopAutoSteal(); stopAutoLeft(); stopAutoRight(); stopAntiRagdoll(); stopAutoTP(); stopHoldInfJump()
    setSnowBatSounds(false); setSnowMedusaSounds(false)
    pcall(function() clearSnowBatSkin(findSnowBat()) end)
    pcall(function() clearSnowMedusaSkin(findSnowMedusa()) end)
    if stretchRezEnabled then disableStretchRez() end
    if hadFPSBoost then disableFPSBoost() elseif antiLagEnabled then disableAntiLag() end
    saveConfig()
end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then modeValLbl.Text=carrySpeedActive and "Lagger Carry" or "Lagger Mode"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill; local dot=laggerModePillRef.dot; local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255); local OFF=Color3.fromRGB(46,24,38); local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill; local dot=carryModePillRef.dot; local on=carrySpeedActive
        local WHITE=Color3.fromRGB(255,255,255); local OFF=Color3.fromRGB(46,24,38); local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end

_prevCarryBeforeLagger = false
function Dragon.setExclusiveSpeed(profile)
    local states={
        CARRY={lagger=false,carry=true},
        LAGGER_NORMAL={lagger=true,carry=false},
        LAGGER_CARRY={lagger=true,carry=true},
        NORMAL={lagger=false,carry=false},
    }
    local state=states[profile] or states.NORMAL
    laggerModeEnabled=state.lagger; carrySpeedActive=state.carry
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(profile=="CARRY") end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(profile=="LAGGER_CARRY") end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(profile=="LAGGER_NORMAL") end
    if GuiToggleSetters and GuiToggleSetters.carryMode then pcall(function() GuiToggleSetters.carryMode(profile=="CARRY") end) end
end
toggleCarryMode=function()
    Dragon.setExclusiveSpeed((not laggerModeEnabled and carrySpeedActive) and "NORMAL" or "CARRY")
end
toggleLaggerMode=function()
    -- Cycle: OFF -> Lagger Normal -> Lagger Carry -> Lagger Normal.
    -- Normal Key is the explicit way to leave the Lagger mode.
    if not laggerModeEnabled then Dragon.setExclusiveSpeed("LAGGER_NORMAL")
    elseif not carrySpeedActive then Dragon.setExclusiveSpeed("LAGGER_CARRY")
    else Dragon.setExclusiveSpeed("LAGGER_NORMAL") end
end

-- Dedicated Lagger Carry toggle (ON/OFF only for carry lagger)
toggleLaggerCarry=function()
    Dragon.setExclusiveSpeed((laggerModeEnabled and carrySpeedActive) and "NORMAL" or "LAGGER_CARRY")
end
-- Retained for integrations which still call the old function name.  The
-- actual input dispatch below uses KB.SpeedToggle, so both routes now perform
-- exactly the same action.
function speedToggleAction() toggleCarryMode() end

-- Clean anti-ragdoll engines.  V1 removes the ragdoll constraints; V2 restores
-- the humanoid state and joints.  Only the selected engine is ever running.
Dragon.antiRagdollVersion="V1"
local CleanAntiRagdollV1={active=false,connections={},lastBoost=0}
local CleanAntiRagdollV2={active=false,connection=nil,lastRecovery=0}
local function cleanDisconnectAllV1()
    for _,connection in ipairs(CleanAntiRagdollV1.connections) do pcall(function() connection:Disconnect() end) end
    table.clear(CleanAntiRagdollV1.connections)
end
local function cleanSpeed()
    if Dragon and Dragon.getActiveMoveSpeed then return Dragon.getActiveMoveSpeed() end
    return 16
end
local function cleanRagdolled(hum)
    local state=hum:GetState()
    return state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown
end
local function cleanEnableControls()
    pcall(function()
        local playerScripts=LP:FindFirstChild("PlayerScripts")
        local playerModule=playerScripts and playerScripts:FindFirstChild("PlayerModule")
        local controlModule=playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then local controls=require(controlModule); if controls then controls:Enable() end end
    end)
end
local function cleanStabilizeRagdollRoot(root)
    if not root or not root.Parent then return end
    -- Clear a hit impulse before restoring control; Anti Bat can otherwise
    -- preserve it long enough to launch the character after recovery.
    pcall(function()
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        root.Velocity=Vector3.zero
        root.RotVelocity=Vector3.zero
    end)
    task.delay(.08,function()
        if root and root.Parent then
            pcall(function()
                root.AssemblyLinearVelocity=Vector3.zero
                root.AssemblyAngularVelocity=Vector3.zero
            end)
        end
    end)
end
local function cleanRecoverV1(character,hum)
    pcall(function()
        -- Keep the planar speed actuator off while Clean restores the body.
        -- It never applies vertical force, so roofs remain handled by Roblox.
        Dragon.cleanRagdollRecovering=true; task.delay(.05,function() Dragon.cleanRagdollRecovering=false end)
        LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow())
        for _,object in ipairs(character:GetDescendants()) do
            if object:IsA("BallSocketConstraint") or (object:IsA("Attachment") and string.find(object.Name,"RagdollAttachment")) then object:Destroy() end
        end
        local root=character:FindFirstChild("HumanoidRootPart")
        if root then root.Anchored=false; cleanStabilizeRagdollRoot(root) end
        hum.WalkSpeed=cleanSpeed(); hum:ChangeState(Enum.HumanoidStateType.Running); cleanEnableControls()
    end)
end
local function startCleanAntiRagdollV1()
    if CleanAntiRagdollV1.active then return end
    CleanAntiRagdollV1.active=true
    table.insert(CleanAntiRagdollV1.connections,RunService.Heartbeat:Connect(function()
        if not CleanAntiRagdollV1.active or not antiRagdollEnabled then return end
        local character=LP.Character; local hum=character and character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 or not cleanRagdolled(hum) then return end
        Dragon.cleanRagdollDetectedUntil=tick()+1.35
        if Dragon.cleanRagdollAlert then Dragon.cleanRagdollAlert() end
        local now=tick()
        if now-CleanAntiRagdollV1.lastBoost>=0.05 then CleanAntiRagdollV1.lastBoost=now; cleanRecoverV1(character,hum) end
    end))
    table.insert(CleanAntiRagdollV1.connections,RunService.RenderStepped:Connect(function()
        if CleanAntiRagdollV1.active then local c=LP.Character; local hum=c and c:FindFirstChildOfClass("Humanoid"); if hum and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=hum end end
    end))
end
local function stopCleanAntiRagdollV1() CleanAntiRagdollV1.active=false; cleanDisconnectAllV1() end
local function startCleanAntiRagdollV2()
    if CleanAntiRagdollV2.connection then return end
    CleanAntiRagdollV2.active=true
    CleanAntiRagdollV2.connection=RunService.Heartbeat:Connect(function()
        if not CleanAntiRagdollV2.active or not antiRagdollEnabled then return end
        local character=LP.Character; local hum=character and character:FindFirstChildOfClass("Humanoid"); local root=character and character:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not cleanRagdolled(hum) or tick()-CleanAntiRagdollV2.lastRecovery<0.15 then return end
        Dragon.cleanRagdollDetectedUntil=tick()+1.35
        if Dragon.cleanRagdollAlert then Dragon.cleanRagdollAlert() end
        CleanAntiRagdollV2.lastRecovery=tick()
        pcall(function()
            Dragon.cleanRagdollRecovering=true; task.delay(.05,function() Dragon.cleanRagdollRecovering=false end)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            if root then cleanStabilizeRagdollRoot(root) end
            for _,object in ipairs(character:GetDescendants()) do if object:IsA("Motor6D") or object:IsA("Constraint") then object.Enabled=true end end
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=hum end
            cleanEnableControls()
            hum.AutoRotate=true; hum.PlatformStand=false; hum.Sit=false
        end)
    end)
end
local function stopCleanAntiRagdollV2()
    CleanAntiRagdollV2.active=false
    if CleanAntiRagdollV2.connection then CleanAntiRagdollV2.connection:Disconnect(); CleanAntiRagdollV2.connection=nil end
end
startAntiRagdoll=function()
    stopCleanAntiRagdollV1(); stopCleanAntiRagdollV2()
    -- Version labels deliberately map to the opposite Clean engines:
    -- V1 = Clean V2 recovery, V2 = Clean V1 constraint recovery.
    if Dragon.antiRagdollVersion=="V1" then startCleanAntiRagdollV2() else startCleanAntiRagdollV1() end
end
stopAntiRagdoll=function() stopCleanAntiRagdollV1(); stopCleanAntiRagdollV2() end
startUnwalk=function()
    local c=LP.Character; if not c then return end; local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate"); if anim then unwalkSavedAnimate=anim:Clone(); anim:Destroy() end
end
stopUnwalk=function()
    local c=LP.Character; if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c; unwalkSavedAnimate=nil end
end

-- ============================================================
-- STEAL BAR
-- ============================================================
Dragon_PROFILE_PRIMARY="rbxassetid://91781095721218"
Dragon_PROFILE_ALTERNATE="rbxassetid://91781095721218"
dragonProfileAlternate=false
function DragonCurrentProfileAsset()
    return Dragon_PROFILE_PRIMARY
end
function DragonRefreshProfileImages()
    local asset=DragonCurrentProfileAsset()
    for _,root in ipairs({GuiRefs and GuiRefs.hub,stealBarFrame}) do
        if root then
            for _,item in ipairs(root:GetDescendants()) do
                if item.Name=="DragonProfileImage" and (item:IsA("ImageLabel") or item:IsA("ImageButton")) then item.Image=asset end
            end
        end
    end
end
function DragonToggleProfileImage()
    dragonProfileAlternate=false
    DragonRefreshProfileImages()
    if saveConfig then saveConfig() end
end
function createStealBar()
    if not Dragon_INTRO_DONE then
        if not Dragon_STEALBAR_QUEUED then
            Dragon_STEALBAR_QUEUED=true
            dragonAfterIntro(function() Dragon_STEALBAR_QUEUED=false; createStealBar() end)
        end
        return
    end
    -- Keep the current coordinates when this function rebuilds the bar after
    -- a scale change.
    if stealBarFrame and stealBarFrame.Parent and not stealBarResetRequested then
        stealBarPosition={xs=stealBarFrame.Position.X.Scale,xo=stealBarFrame.Position.X.Offset,ys=stealBarFrame.Position.Y.Scale,yo=stealBarFrame.Position.Y.Offset}
    end
    stealBarResetRequested=false
    for _,n in ipairs({"SnowStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui"); if pgui then local o=pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    local stealGui=Instance.new("ScreenGui")
    stealGui.Name="SnowStealBar"; stealGui.ResetOnSpawn=false; stealGui.IgnoreGuiInset=true; stealGui.DisplayOrder=8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end

    -- High-ping warning: brief top-center banner, shown at most once per cycle.
    local pingBanner=Instance.new("Frame",stealGui)
    pingBanner.Name="PingBanner"; pingBanner.Size=UDim2.new(0,260,0,48); pingBanner.Position=UDim2.new(0.5,-130,0,-60)
    pingBanner.BackgroundColor3=Color3.fromRGB(120,10,10); pingBanner.BorderSizePixel=0; pingBanner.Visible=false; pingBanner.ZIndex=200
    Instance.new("UICorner",pingBanner).CornerRadius=UDim.new(0,10)
    local pingBannerStroke=Instance.new("UIStroke",pingBanner); pingBannerStroke.Color=Color3.fromRGB(200,50,50); pingBannerStroke.Thickness=1.5
    local pingIcon=Instance.new("TextLabel",pingBanner)
    pingIcon.Size=UDim2.new(0,28,1,0); pingIcon.Position=UDim2.new(0,8,0,0); pingIcon.BackgroundTransparency=1; pingIcon.Text="⚠"; pingIcon.TextColor3=Color3.fromRGB(255,200,50); pingIcon.Font=Enum.Font.GothamBlack; pingIcon.TextSize=20; pingIcon.TextXAlignment=Enum.TextXAlignment.Center; pingIcon.TextYAlignment=Enum.TextYAlignment.Center; pingIcon.ZIndex=201
    local pingBannerTitle=Instance.new("TextLabel",pingBanner)
    pingBannerTitle.Size=UDim2.new(1,-44,0,22); pingBannerTitle.Position=UDim2.new(0,38,0,4); pingBannerTitle.BackgroundTransparency=1; pingBannerTitle.Text="HIGH PING - DON'T DUEL"; pingBannerTitle.TextColor3=Color3.fromRGB(255,255,255); pingBannerTitle.Font=Enum.Font.GothamBlack; pingBannerTitle.TextSize=11; pingBannerTitle.TextXAlignment=Enum.TextXAlignment.Left; pingBannerTitle.ZIndex=201
    local pingBannerSub=Instance.new("TextLabel",pingBanner)
    pingBannerSub.Size=UDim2.new(1,-44,0,16); pingBannerSub.Position=UDim2.new(0,38,0,27); pingBannerSub.BackgroundTransparency=1; pingBannerSub.TextColor3=Color3.fromRGB(220,180,180); pingBannerSub.Font=Enum.Font.GothamBold; pingBannerSub.TextSize=9; pingBannerSub.TextXAlignment=Enum.TextXAlignment.Left; pingBannerSub.ZIndex=201
    Dragon.alertLayout.pingBanner=pingBanner
    local pingBannerBusy=false
    local function pingBannerPosition(y)
        -- Keep both alerts grouped at screen center with a 10px gap.
        if Dragon.alertLayout and Dragon.alertLayout.e01Visible then return UDim2.new(0.5,-285,0,y) end
        return UDim2.new(0.5,-130,0,y)
    end
    local function showPingBanner(ms)
        if pingBannerBusy or hidePingWarner or not pingBanner.Parent then return end
        pingBannerBusy=true; Dragon.alertLayout.pingVisible=true; pingBannerSub.Text=tostring(ms).."ms (over 120ms)"; pingBanner.Visible=true; pingBanner.Position=pingBannerPosition(-60)
        TweenService:Create(pingBanner,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=pingBannerPosition(8)}):Play()
        task.delay(3,function()
            if not pingBanner.Parent then return end
            TweenService:Create(pingBanner,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=pingBannerPosition(-60)}):Play()
            task.wait(0.3)
            if pingBanner.Parent then pingBanner.Visible=false; pingBannerBusy=false; Dragon.alertLayout.pingVisible=false end
        end)
    end
    task.spawn(function()
        while pingBanner.Parent do
            local ok,ping=pcall(function() return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()+0.5) end)
            if ok and ping>120 then showPingBanner(ping) end
            task.wait(2)
        end
    end)

    -- Compact Dragon DUELS status bar: portrait at left, status at right.
    local sc=math.clamp(tonumber(stealBarScale) or 1,0.7,1.8)
    local SB_W,SB_H=math.floor(330*sc+0.5),math.floor(64*sc+0.5)
    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H)
    if type(stealBarPosition)=="table" then
        stealBarFrame.Position=UDim2.new(tonumber(stealBarPosition.xs) or 0.5,tonumber(stealBarPosition.xo) or -SB_W/2,tonumber(stealBarPosition.ys) or 0.88,tonumber(stealBarPosition.yo) or 0)
    else
        stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.88,0)
    end
    stealBarFrame.BackgroundColor3=Color3.fromRGB(0,0,0); stealBarFrame.BackgroundTransparency=0; stealBarFrame.BorderSizePixel=0; stealBarFrame.ZIndex=20; stealBarFrame.Active=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0,math.floor(12*sc+0.5))
    local barBackground=Instance.new("ImageLabel",stealBarFrame)
    barBackground.Name="StealBarBackground"; barBackground.Size=UDim2.fromScale(1,1); barBackground.BackgroundTransparency=1; barBackground.BorderSizePixel=0
    barBackground.Image=stealBarBackgroundUrl; barBackground.ImageTransparency=.52; barBackground.ScaleType=Enum.ScaleType.Crop; barBackground.ZIndex=20
    barBackground.Visible=stealBarBackgroundUrl~=""; Instance.new("UICorner",barBackground).CornerRadius=UDim.new(0,math.floor(12*sc+0.5))
    local barStroke=Instance.new("UIStroke",stealBarFrame); barStroke.Transparency=1
    local portraitFrame=Instance.new("Frame",stealBarFrame)
    portraitFrame.Size=UDim2.new(0,math.floor(44*sc+0.5),0,math.floor(44*sc+0.5)); portraitFrame.Position=UDim2.new(0,math.floor(5*sc+0.5),0.5,-math.floor(22*sc+0.5))
    portraitFrame.BackgroundTransparency=1; portraitFrame.BorderSizePixel=0; portraitFrame.ZIndex=23; Instance.new("UICorner",portraitFrame).CornerRadius=UDim.new(0,math.floor(9*sc+0.5))
    local portrait=Instance.new("ImageLabel",portraitFrame)
    portrait.Name="DragonProfileImage"; portrait.Size=UDim2.new(1,-4,1,-4); portrait.Position=UDim2.new(0,2,0,2); portrait.BackgroundTransparency=1; portrait.Image=DragonCurrentProfileAsset(); portrait.ScaleType=Enum.ScaleType.Crop; portrait.ZIndex=24
    Instance.new("UICorner",portrait).CornerRadius=UDim.new(0,math.floor(7*sc+0.5))
    local pctLbl=Instance.new("TextLabel",stealBarFrame)
    pctLbl.Size=UDim2.new(0,math.floor(78*sc+0.5),0,math.floor(17*sc+0.5)); pctLbl.Position=UDim2.new(0,math.floor(59*sc+0.5),0,math.floor(5*sc+0.5)); pctLbl.BackgroundTransparency=1; pctLbl.Text="0%"; pctLbl.TextColor3=Color3.fromRGB(255,255,255); pctLbl.Font=Enum.Font.GothamBlack; pctLbl.TextSize=math.max(10,math.floor(13*sc+0.5)); pctLbl.TextXAlignment=Enum.TextXAlignment.Left; pctLbl.ZIndex=24
    local fpsLbl=Instance.new("TextLabel",stealBarFrame)
    fpsLbl.Size=UDim2.new(0,math.floor(145*sc+0.5),0,math.floor(15*sc+0.5)); fpsLbl.Position=UDim2.new(1,-math.floor(157*sc+0.5),0,math.floor(25*sc+0.5)); fpsLbl.BackgroundTransparency=1; fpsLbl.Text="FPS -- | PING --"; fpsLbl.TextColor3=Color3.fromRGB(210,220,225); fpsLbl.Font=Enum.Font.GothamBold; fpsLbl.TextSize=math.max(7,math.floor(9*sc+0.5)); fpsLbl.TextXAlignment=Enum.TextXAlignment.Right; fpsLbl.ZIndex=24
    local radiusLbl=Instance.new("TextLabel",stealBarFrame)
    radiusLbl.Size=UDim2.new(0,math.floor(112*sc+0.5),0,math.floor(15*sc+0.5)); radiusLbl.Position=UDim2.new(0,math.floor(59*sc+0.5),0,math.floor(25*sc+0.5)); radiusLbl.BackgroundTransparency=1; radiusLbl.Text="RADIUS "..tostring(math.floor(Steal.StealRadius)); radiusLbl.TextColor3=Color3.fromRGB(210,220,225); radiusLbl.Font=Enum.Font.GothamBold; radiusLbl.TextSize=math.max(7,math.floor(9*sc+0.5)); radiusLbl.TextXAlignment=Enum.TextXAlignment.Left; radiusLbl.ZIndex=24
    local pingLbl=Instance.new("TextLabel",stealBarFrame)
    pingLbl.Visible=false
    local track=Instance.new("Frame",stealBarFrame)
    track.Size=UDim2.new(1,-math.floor(72*sc+0.5),0,math.floor(16*sc+0.5)); track.Position=UDim2.new(0,math.floor(60*sc+0.5),1,-math.floor(21*sc+0.5)); track.BackgroundColor3=Color3.fromRGB(42,47,53); track.BackgroundTransparency=.12; track.BorderSizePixel=0; track.ClipsDescendants=true; track.ZIndex=21; track.Visible=true
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local fillLine=Instance.new("Frame",track); fillLine.Name="FillLine"
    fillLine.Size=UDim2.new(0,0,1,0); fillLine.BackgroundColor3=Color3.fromRGB(255,255,255); fillLine.BorderSizePixel=0; fillLine.ZIndex=22
    Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
    local fillGrad=Instance.new("UIGradient",fillLine); fillGrad.Color=ColorSequence.new(Color3.fromRGB(238,243,247),Color3.fromRGB(255,255,255))
    task.spawn(function()
        local frames,t0=0,tick()
        while fillLine and fillLine.Parent do
            frames=frames+1
            local now=tick()
            if Steal.AutoStealEnabled then
                local pct=math.clamp(tonumber(stealVisualPct) or 0,0,1)
                fillLine.Size=UDim2.new(pct,0,1,0); pctLbl.Text=string.format("%d%%",math.floor(pct*100+0.5))
                fillGrad.Offset=Vector2.new(math.sin(now*3)*0.3,0)
            else
                fillLine.Size=UDim2.new(0,0,1,0); pctLbl.Text="0%"
            end
            radiusLbl.Text="RADIUS "..tostring(math.floor(Steal.StealRadius))
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5); local ping="--"
                pcall(function() ping=tostring(math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()+0.5)).."ms" end)
                fpsLbl.Text="FPS "..tostring(fps).." | PING "..ping; frames=0; t0=now
            end
            task.wait()
        end
    end)
    local dragging,dragStart,dragPos=false,nil,nil
    local function saveStealBarPlacement()
        if not stealBarFrame or not stealBarFrame.Parent then return end
        stealBarPosition={xs=stealBarFrame.Position.X.Scale,xo=stealBarFrame.Position.X.Offset,ys=stealBarFrame.Position.Y.Scale,yo=stealBarFrame.Position.Y.Offset}
        pcall(saveConfig)
    end
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked or stealBarLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; dragPos=stealBarFrame.Position
            -- Mobile touch end is most reliable on the input itself, rather
            -- than only on UserInputService's global InputEnded signal.
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End and dragging then dragging=false; saveStealBarPlacement() end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart; stealBarFrame.Position=UDim2.new(dragPos.X.Scale,dragPos.X.Offset+delta.X,dragPos.Y.Scale,dragPos.Y.Offset+delta.Y)
            stealBarPosition={xs=stealBarFrame.Position.X.Scale,xo=stealBarFrame.Position.X.Offset,ys=stealBarFrame.Position.Y.Scale,yo=stealBarFrame.Position.Y.Offset}
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            if dragging then
                dragging=false
                saveStealBarPlacement()
            end
        end
    end)
    if false then -- Legacy style implementations retained but permanently disabled.
    local fillLine, fillGrad, pctLbl, fpsLbl, pingLbl, warnFrame, warnLbl

    if style == 1 then
        -- ========== STYLE 1: VERTICAL (full-bar look, next to menu) ==========
        local sc = math.clamp(tonumber(stealBarScale) or 1, 0.7, 1.8)
        local SB_W = math.floor(64 * sc + 0.5)
        local SB_H = math.floor(220 * sc + 0.5)
        local AV_SIZE = math.floor(28 * sc + 0.5)
        local WHITE=Color3.fromRGB(255,255,255)
        local BARBG=Color3.fromRGB(18,10,15)

        stealBarFrame=Instance.new("Frame",stealGui)
        stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H)
        stealBarFrame.Position=UDim2.new(0, 300, 0.5, -SB_H/2)
        stealBarFrame.BackgroundColor3=BARBG
        stealBarFrame.BorderSizePixel=0
        stealBarFrame.ZIndex=20
        stealBarFrame.ClipsDescendants=true
        stealBarFrame.Visible=not stealBarHidden
        stealBarFrame.Active=true
        Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0, math.floor(18*sc+0.5))
        local sbStroke=Instance.new("UIStroke",stealBarFrame)
        sbStroke.Color=WHITE
        sbStroke.Thickness=2
        sbStroke.Transparency=0.3

        task.defer(function()
            pcall(function()
                local outer = GuiRefs and GuiRefs.outer
                if outer and outer.Parent then
                    local abs = outer.AbsolutePosition
                    local asz = outer.AbsoluteSize
                    local x = abs.X + asz.X + 12
                    local y = abs.Y + asz.Y * 0.5 - SB_H * 0.5
                    stealBarFrame.Position = UDim2.new(0, math.floor(x), 0, math.floor(y))
                end
            end)
        end)

        local galaxyLayer=Instance.new("Frame",stealBarFrame)
        galaxyLayer.Name="Galaxy"
        galaxyLayer.Size=UDim2.new(1,0,1,0)
        galaxyLayer.BackgroundTransparency=1
        galaxyLayer.BorderSizePixel=0
        galaxyLayer.ZIndex=20
        galaxyLayer.ClipsDescendants=true
        Instance.new("UICorner",galaxyLayer).CornerRadius=UDim.new(0, math.floor(18*sc+0.5))
        local neb1=Instance.new("Frame",galaxyLayer)
        neb1.Size=UDim2.new(1.2,0,0.55,0); neb1.Position=UDim2.new(-0.1,0,-0.05,0)
        neb1.BackgroundColor3=Color3.fromRGB(90,40,180); neb1.BackgroundTransparency=0.82
        neb1.BorderSizePixel=0; neb1.ZIndex=20
        Instance.new("UICorner",neb1).CornerRadius=UDim.new(1,0)
        local neb2=Instance.new("Frame",galaxyLayer)
        neb2.Size=UDim2.new(1.2,0,0.5,0); neb2.Position=UDim2.new(-0.1,0,0.55,0)
        neb2.BackgroundColor3=Color3.fromRGB(40,80,200); neb2.BackgroundTransparency=0.85
        neb2.BorderSizePixel=0; neb2.ZIndex=20
        Instance.new("UICorner",neb2).CornerRadius=UDim.new(1,0)
        local rng=Random.new()
        for i=1,18 do
            local star=Instance.new("Frame",galaxyLayer)
            local sz=rng:NextInteger(1,2)
            star.Size=UDim2.new(0,sz,0,sz)
            star.Position=UDim2.new(rng:NextNumber(0.1,0.9),0,rng:NextNumber(0.08,0.92),0)
            star.BackgroundColor3=Color3.fromRGB(220+rng:NextInteger(0,35),210+rng:NextInteger(0,40),255)
            star.BackgroundTransparency=rng:NextNumber(0.15,0.55)
            star.BorderSizePixel=0; star.ZIndex=21
            Instance.new("UICorner",star).CornerRadius=UDim.new(1,0)
            task.spawn(function()
                while star and star.Parent do
                    local t=TweenService:Create(star,TweenInfo.new(rng:NextNumber(0.8,2.2),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                        BackgroundTransparency=rng:NextNumber(0.05,0.7)
                    })
                    t:Play(); t.Completed:Wait()
                end
            end)
        end

        local avRing=Instance.new("Frame",stealBarFrame)
        avRing.Size=UDim2.new(0,AV_SIZE,0,AV_SIZE)
        avRing.Position=UDim2.new(0.5,-AV_SIZE/2,0, math.floor(8*sc+0.5))
        avRing.BackgroundColor3=Color3.fromRGB(30,20,28)
        avRing.BorderSizePixel=0; avRing.ZIndex=28
        Instance.new("UICorner",avRing).CornerRadius=UDim.new(1,0)
        local avStroke=Instance.new("UIStroke",avRing)
        avStroke.Color=WHITE; avStroke.Thickness=1.2; avStroke.Transparency=0.35
        local avImg=Instance.new("ImageLabel",avRing)
        avImg.Size=UDim2.new(1,-2,1,-2); avImg.Position=UDim2.new(0,1,0,1)
        avImg.BackgroundTransparency=1; avImg.BorderSizePixel=0; avImg.ZIndex=29
        avImg.ScaleType=Enum.ScaleType.Crop
        avImg.Image="rbxassetid://91781095721218"
        Instance.new("UICorner",avImg).CornerRadius=UDim.new(1,0)

        pctLbl=Instance.new("TextLabel",stealBarFrame)
        pctLbl.Size=UDim2.new(1,-6,0, math.floor(18*sc+0.5))
        pctLbl.Position=UDim2.new(0,3,0, math.floor(8*sc+0.5)+AV_SIZE+2)
        pctLbl.BackgroundTransparency=1
        pctLbl.Text="0%"
        pctLbl.TextColor3=WHITE
        pctLbl.Font=Enum.Font.GothamBlack
        pctLbl.TextSize=math.max(11, math.floor(13*sc+0.5))
        pctLbl.ZIndex=26

        local nameLbl=Instance.new("TextLabel",stealBarFrame)
        nameLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        nameLbl.Position=UDim2.new(0,3,0, math.floor(8*sc+0.5)+AV_SIZE+math.floor(18*sc+0.5))
        nameLbl.BackgroundTransparency=1
        nameLbl.Text="STEAL"
        nameLbl.TextColor3=WHITE
        nameLbl.Font=Enum.Font.GothamBold
        nameLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        nameLbl.ZIndex=26

        local topContent = math.floor(8*sc+0.5)+AV_SIZE+math.floor(32*sc+0.5)
        local botContent = math.floor(34*sc+0.5)
        local track=Instance.new("Frame",stealBarFrame)
        track.Size=UDim2.new(0, math.floor(14*sc+0.5), 1, -(topContent + botContent))
        track.Position=UDim2.new(0.5, -math.floor(7*sc+0.5), 0, topContent)
        track.BackgroundColor3=Color3.fromRGB(30,18,26)
        track.BorderSizePixel=0
        track.ZIndex=21
        track.ClipsDescendants=true
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local trackStroke=Instance.new("UIStroke",track)
        trackStroke.Color=WHITE; trackStroke.Thickness=1; trackStroke.Transparency=0.55

        fillLine=Instance.new("Frame",track)
        fillLine.AnchorPoint=Vector2.new(0,1)
        fillLine.Size=UDim2.new(1,0,0,0)
        fillLine.Position=UDim2.new(0,0,1,0)
        fillLine.BackgroundColor3=WHITE
        fillLine.BorderSizePixel=0
        fillLine.ZIndex=22
        Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
        fillGrad=Instance.new("UIGradient",fillLine)
        fillGrad.Rotation=90
        fillGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(200,200,200)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200)),
        })

        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        fpsLbl.Position=UDim2.new(0,3,1, -math.floor(28*sc+0.5))
        fpsLbl.BackgroundTransparency=1
        fpsLbl.Text="--"
        fpsLbl.TextColor3=WHITE
        fpsLbl.Font=Enum.Font.GothamBold
        fpsLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        fpsLbl.ZIndex=26

        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        pingLbl.Position=UDim2.new(0,3,1, -math.floor(14*sc+0.5))
        pingLbl.BackgroundTransparency=1
        pingLbl.Text="--"
        pingLbl.TextColor3=WHITE
        pingLbl.Font=Enum.Font.GothamBold
        pingLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        pingLbl.ZIndex=26

        warnFrame=Instance.new("Frame",stealGui)

        warnFrame.Name="PingWarner"
        warnFrame.Size=UDim2.new(0, math.floor(322*sc+0.5), 0, math.floor(46*sc+0.5))
        warnFrame.Position=UDim2.new(0.5, -math.floor(161*sc+0.5), 0, math.floor(38*sc+0.5))
        warnFrame.BackgroundColor3=Color3.fromRGB(120,0,0)
        warnFrame.BackgroundTransparency=0.06
        warnFrame.BorderSizePixel=0
        warnFrame.Visible=false
        warnFrame.ZIndex=25
        Instance.new("UICorner",warnFrame).CornerRadius=UDim.new(1,0)
        warnLbl=Instance.new("TextLabel",warnFrame)
        warnLbl.Size=UDim2.new(1,0,1,0)
        warnLbl.BackgroundTransparency=1
        warnLbl.Text=""
        warnLbl.TextColor3=Color3.fromRGB(255,255,255)
        warnLbl.Font=Enum.Font.GothamBold
        warnLbl.TextSize=math.max(9, math.floor(11*sc+0.5))
        warnLbl.TextWrapped=true
        warnLbl.TextYAlignment=Enum.TextYAlignment.Center
        warnLbl.ZIndex=26

        task.spawn(function()
            local frames=0; local t0=tick()
            while fpsLbl and fpsLbl.Parent do
                frames=frames+1; local now=tick()
                if now-t0>=0.5 then
                    local fps=math.floor(frames/(now-t0)+0.5)
                    fpsLbl.Text=tostring(fps).." fps"
                    frames=0; t0=now
                end
                task.wait()
            end
        end)
        task.spawn(function()
            while pingLbl and pingLbl.Parent do
                pcall(function()
                    local ping=math.floor((game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())+0.5)
                    local pingColor=WHITE
                    if ping<80 then pingColor=Color3.fromRGB(0,255,120)
                    elseif ping<150 then pingColor=Color3.fromRGB(255,200,0)
                    else pingColor=Color3.fromRGB(255,60,60) end
                    pingLbl.Text=tostring(ping).." ms"
                    pingLbl.TextColor3=pingColor
                    if ping > 120 and not hidePingWarner then
                        warnLbl.Text = "⚠  HIGH PING - DON'T DUEL\n"..tostring(ping).."ms (over 120ms)"
                        warnFrame.Visible = true
                    else
                        warnFrame.Visible = false
                    end
                end)
                task.wait(0.5)
            end
        end)

        stealBarFrame:SetAttribute("StealStyle", 1)
    else
        -- ========== STYLE 2: current full bar (scalable) ==========
        local sc = math.clamp(tonumber(stealBarScale) or 1, 0.7, 1.8)
        local SB_W,SB_H=math.floor(360*sc+0.5), math.floor(40*sc+0.5)
        local AV_SIZE=math.floor(32*sc+0.5)
        stealBarFrame=Instance.new("Frame",stealGui)
        stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H); stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.88,0)
        stealBarFrame.BackgroundColor3=BARBG; stealBarFrame.BorderSizePixel=0; stealBarFrame.ZIndex=20; stealBarFrame.ClipsDescendants=true
        stealBarFrame.Visible=not stealBarHidden
        stealBarFrame.Active=true
        Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(1,0)
        local sbStroke=Instance.new("UIStroke",stealBarFrame); sbStroke.Color=WHITE; sbStroke.Thickness=2; sbStroke.Transparency=0.3
        local galaxyLayer=Instance.new("Frame",stealBarFrame)
        galaxyLayer.Name="Galaxy"
        galaxyLayer.Size=UDim2.new(1,0,1,0)
        galaxyLayer.BackgroundTransparency=1
        galaxyLayer.BorderSizePixel=0
        galaxyLayer.ZIndex=20
        galaxyLayer.ClipsDescendants=true
        Instance.new("UICorner",galaxyLayer).CornerRadius=UDim.new(1,0)
        local neb1=Instance.new("Frame",galaxyLayer)
        neb1.Size=UDim2.new(0.55,0,1.4,0); neb1.Position=UDim2.new(-0.05,0,-0.2,0)
        neb1.BackgroundColor3=Color3.fromRGB(90,40,180); neb1.BackgroundTransparency=0.82
        neb1.BorderSizePixel=0; neb1.ZIndex=20
        Instance.new("UICorner",neb1).CornerRadius=UDim.new(1,0)
        local neb2=Instance.new("Frame",galaxyLayer)
        neb2.Size=UDim2.new(0.5,0,1.3,0); neb2.Position=UDim2.new(0.55,0,-0.15,0)
        neb2.BackgroundColor3=Color3.fromRGB(40,80,200); neb2.BackgroundTransparency=0.85
        neb2.BorderSizePixel=0; neb2.ZIndex=20
        Instance.new("UICorner",neb2).CornerRadius=UDim.new(1,0)
        local rng=Random.new()
        for i=1,28 do
            local star=Instance.new("Frame",galaxyLayer)
            local sz=rng:NextInteger(1,2)
            star.Size=UDim2.new(0,sz,0,sz)
            star.Position=UDim2.new(rng:NextNumber(0.02,0.98),0,rng:NextNumber(0.1,0.9),0)
            star.BackgroundColor3=Color3.fromRGB(220+rng:NextInteger(0,35),210+rng:NextInteger(0,40),255)
            star.BackgroundTransparency=rng:NextNumber(0.15,0.55)
            star.BorderSizePixel=0; star.ZIndex=21
            Instance.new("UICorner",star).CornerRadius=UDim.new(1,0)
            task.spawn(function()
                while star and star.Parent do
                    local t=TweenService:Create(star,TweenInfo.new(rng:NextNumber(0.8,2.2),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                        BackgroundTransparency=rng:NextNumber(0.05,0.7)
                    })
                    t:Play(); t.Completed:Wait()
                end
            end)
        end
        task.spawn(function()
            while galaxyLayer and galaxyLayer.Parent do
                task.wait(rng:NextNumber(2.2,4.5))
                local ss=Instance.new("Frame",galaxyLayer)
                ss.BackgroundColor3=Color3.fromRGB(210,190,255)
                ss.Size=UDim2.new(0,rng:NextInteger(18,36),0,1)
                ss.Position=UDim2.new(rng:NextNumber(0,0.5),0,rng:NextNumber(0.15,0.75),0)
                ss.Rotation=-18; ss.BackgroundTransparency=0.1; ss.BorderSizePixel=0; ss.ZIndex=22
                Instance.new("UICorner",ss).CornerRadius=UDim.new(1,0)
                TweenService:Create(ss,TweenInfo.new(0.45,Enum.EasingStyle.Linear),{
                    Position=UDim2.new(ss.Position.X.Scale+0.35,0,ss.Position.Y.Scale+0.2,0),
                    BackgroundTransparency=1
                }):Play()
                task.delay(0.5,function() if ss then ss:Destroy() end end)
            end
        end)
        local avRing=Instance.new("Frame",stealBarFrame)
        avRing.Size=UDim2.new(0,AV_SIZE,0,AV_SIZE)
        avRing.Position=UDim2.new(0,4,0.5,-AV_SIZE/2)
        avRing.BackgroundColor3=Color3.fromRGB(30,20,28)
        avRing.BorderSizePixel=0; avRing.ZIndex=28
        Instance.new("UICorner",avRing).CornerRadius=UDim.new(1,0)
        local avImg=Instance.new("ImageLabel",avRing)
        avImg.Size=UDim2.new(1,-2,1,-2); avImg.Position=UDim2.new(0,1,0,1)
        avImg.BackgroundTransparency=1; avImg.BorderSizePixel=0; avImg.ZIndex=29
        avImg.ScaleType=Enum.ScaleType.Crop
        avImg.Image="rbxassetid://91781095721218"
        Instance.new("UICorner",avImg).CornerRadius=UDim.new(1,0)

        fillLine=Instance.new("Frame",stealBarFrame); fillLine.Size=UDim2.new(0,0,1,0)
        fillLine.BackgroundColor3=WHITE; fillLine.BorderSizePixel=0; fillLine.ZIndex=21
        Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
        fillGrad=Instance.new("UIGradient",fillLine)
        fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200))})
        local leftPad=AV_SIZE+12
        local stealSection=Instance.new("Frame",stealBarFrame)
        stealSection.Size=UDim2.new(0,110,1,0); stealSection.Position=UDim2.new(0,leftPad,0,0); stealSection.BackgroundTransparency=1; stealSection.ZIndex=25
        local stealLbl=Instance.new("TextLabel",stealSection)
        stealLbl.Size=UDim2.new(0,55,1,0); stealLbl.Position=UDim2.new(0,0,0,0); stealLbl.BackgroundTransparency=1
        stealLbl.Text="STEAL"; stealLbl.TextColor3=WHITE; stealLbl.Font=Enum.Font.GothamBlack; stealLbl.TextSize=12
        stealLbl.TextXAlignment=Enum.TextXAlignment.Left; stealLbl.ZIndex=26
        stealBarFrame:SetAttribute("StealStyle", 2)
        pctLbl=Instance.new("TextLabel",stealSection)
        pctLbl.Size=UDim2.new(0,50,1,0); pctLbl.Position=UDim2.new(0,55,0,0); pctLbl.BackgroundTransparency=1
        pctLbl.Text="0%"; pctLbl.TextColor3=WHITE; pctLbl.Font=Enum.Font.GothamBlack; pctLbl.TextSize=12
        pctLbl.TextXAlignment=Enum.TextXAlignment.Left; pctLbl.ZIndex=26
        local div1=Instance.new("Frame",stealBarFrame)
        div1.Size=UDim2.new(0,1,0,SB_H*0.45); div1.Position=UDim2.new(0,leftPad+110,0.5,-(SB_H*0.45)/2)
        div1.BackgroundColor3=WHITE; div1.BackgroundTransparency=0.6; div1.BorderSizePixel=0; div1.ZIndex=25
        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(0,68,1,0); fpsLbl.Position=UDim2.new(0,leftPad+118,0,0); fpsLbl.BackgroundTransparency=1
        fpsLbl.Text="FPS: --"; fpsLbl.TextColor3=WHITE; fpsLbl.Font=Enum.Font.GothamBold; fpsLbl.TextSize=10
        fpsLbl.TextXAlignment=Enum.TextXAlignment.Left; fpsLbl.ZIndex=26
        task.spawn(function()
            local frames=0; local t0=tick()
            while fpsLbl and fpsLbl.Parent do
                frames=frames+1; local now=tick()
                if now-t0>=0.5 then
                    local fps=math.floor(frames/(now-t0)+0.5); fpsLbl.Text="FPS: "..tostring(fps); frames=0; t0=now
                end
                task.wait()
            end
        end)
        local div2=Instance.new("Frame",stealBarFrame)
        div2.Size=UDim2.new(0,1,0,SB_H*0.45); div2.Position=UDim2.new(0,leftPad+190,0.5,-(SB_H*0.45)/2)
        div2.BackgroundColor3=WHITE; div2.BackgroundTransparency=0.6; div2.BorderSizePixel=0; div2.ZIndex=25
        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(0,90,1,0); pingLbl.Position=UDim2.new(0,leftPad+198,0,0); pingLbl.BackgroundTransparency=1
        pingLbl.Text="PING: --"; pingLbl.TextColor3=WHITE; pingLbl.Font=Enum.Font.GothamBold; pingLbl.TextSize=10
        pingLbl.TextXAlignment=Enum.TextXAlignment.Left; pingLbl.ZIndex=26

        warnFrame=Instance.new("Frame",stealGui)

        warnFrame.Name="PingWarner"
        warnFrame.Size=UDim2.new(0,322,0,46)
        warnFrame.Position=UDim2.new(0.5,-161,0,38)
        warnFrame.BackgroundColor3=Color3.fromRGB(120,0,0)
        warnFrame.BackgroundTransparency=0.06
        warnFrame.BorderSizePixel=0
        warnFrame.Visible=false
        warnFrame.ZIndex=30
        Instance.new("UICorner",warnFrame).CornerRadius=UDim.new(1,0)
        warnLbl=Instance.new("TextLabel",warnFrame)
        warnLbl.Size=UDim2.new(1,-8,1,0)
        warnLbl.Position=UDim2.new(0,4,0,0)
        warnLbl.BackgroundTransparency=1
        warnLbl.Text=""
        warnLbl.TextColor3=Color3.fromRGB(255,255,255)
        warnLbl.Font=Enum.Font.GothamBold
        warnLbl.TextSize=11
        warnLbl.TextWrapped=true
        warnLbl.TextYAlignment=Enum.TextYAlignment.Center
        warnLbl.ZIndex=31

        task.spawn(function()
            while pingLbl and pingLbl.Parent do
                pcall(function()
                    local ping=math.floor((game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())+0.5)
                    local pingColor=WHITE
                    if ping<80 then pingColor=Color3.fromRGB(0,255,120)
                    elseif ping<150 then pingColor=Color3.fromRGB(255,200,0)
                    else pingColor=Color3.fromRGB(255,60,60) end
                    pingLbl.Text="PING: "..tostring(ping).."ms"; pingLbl.TextColor3=pingColor
                    if ping > 120 and not hidePingWarner then
                        warnLbl.Text = "⚠  HIGH PING - DON'T DUEL\n"..tostring(ping).."ms (over 120ms)"
                        warnFrame.Visible = true
                        warnFrame.Active = true
                    else
                        warnFrame.Visible = false
                        warnFrame.Active = false
                    end
                end)
                task.wait(0.5)
            end
        end)
    end

    -- shared fill update (horizontal style2 / vertical style1)
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now=tick()
            if stealBarFrame then
                stealBarFrame.Visible = not stealBarHidden
                stealBarFrame.Active = true
            end
            local isVert = stealBarFrame and stealBarFrame:GetAttribute("StealStyle") == 1
            if Steal.AutoStealEnabled then
                local pct = tonumber(stealVisualPct) or 0
                if isVert then
                    fillLine.Size=UDim2.new(1,0,pct,0) -- vertical grow
                else
                    fillLine.Size=UDim2.new(pct,0,1,0) -- horizontal grow
                end
                if fillGrad then fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0) end
                if pctLbl then pctLbl.Text=math.floor(pct*100).."%" end
            else
                if isVert then
                    fillLine.Size=UDim2.new(1,0,0,0)
                else
                    fillLine.Size=UDim2.new(0,0,1,0)
                end
                if pctLbl then pctLbl.Text="0%" end
            end
            task.wait(0.016)
        end
    end)

    -- drag
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging2=true; dragStart2=input.Position; dragStartPos2=stealBarFrame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging2=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging2=false; return end
        if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            stealBarFrame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
        end
    end)
    end
end

dragonAfterIntro(createStealBar)

-- ============================================================
-- TP BAT + BAT V2
-- ============================================================
-- Dragon AutoPlay V2 route data. HALF runs the short two-point route; FULL
-- follows all five checkpoints before stopping.
Dragon.autoPlayV2Routes={
    L={FULL={Vector3.new(-475.86,-7,91.97),Vector3.new(-485.83,-7,97.37),Vector3.new(-475.86,-7,91.97),Vector3.new(-476.35,-7,27.88),Vector3.new(-477.09,-7,19.85)},HALF={AP_L1,AP_L2}},
    R={FULL={Vector3.new(-475.84,-7,28.81),Vector3.new(-486.04,-7,23.32),Vector3.new(-475.51,-7,29.01),Vector3.new(-476.43,-7,91.61),Vector3.new(-476.27,-7,98.86)},HALF={AP_R1,AP_R2}},
}
function Dragon.detectAutoPlaySide()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local left=(root.Position-AP_L1).Magnitude; local right=(root.Position-AP_R1).Magnitude
    if math.min(left,right)>30 then return nil end
    return left<=right and "L" or "R"
end
function Dragon.setAutoPlay(on)
    if not autoPlayMode then return end
    if not on then
        autoPlayEnabled=false
        autoPlaySide=nil
        if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
        if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
        return
    end
    autoPlaySide=autoPlaySide or Dragon.detectAutoPlaySide()
    if autoPlaySide=="L" then
        if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
        autoLeftEnabled=true; startAutoLeft()
    elseif autoPlaySide=="R" then
        if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
        autoRightEnabled=true; startAutoRight()
    else
        return
    end
    autoPlayEnabled=true
end

Dragon_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function Dragon.findBat()
    local char=LP.Character; if not char then return nil end
    for _,name in ipairs(Dragon_SLAP_LIST) do local t=char:FindFirstChild(name); if t and t:IsA("Tool") then return t end end
    -- V2: accept every normal melee name, not only the Snow slap list.
    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name=tool.Name:lower()
            if name:find("bat",1,true) or name:find("slap",1,true) or name:find("sword",1,true)
                or name:find("knife",1,true) or name:find("blade",1,true) or name:find("mace",1,true)
                or tool:FindFirstChildWhichIsA("RemoteEvent") or tool:FindFirstChild("Activate") then
                return tool
            end
        end
    end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _,name in ipairs(Dragon_SLAP_LIST) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
        -- Same generic Backpack melee scan used by the supplied V2 logic.
        for _,tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local name=tool.Name:lower()
                if name:find("bat",1,true) or name:find("slap",1,true) or name:find("sword",1,true)
                    or name:find("knife",1,true) or name:find("blade",1,true) or name:find("mace",1,true) then
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                    return tool
                end
            end
        end
    end
    return nil
end
function Dragon.closestRoot()
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil,math.huge end
    local best,dist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart"); local hum=p.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health>0 then
                local d=(tr.Position-root.Position).Magnitude
                if d<dist then dist=d; best=tr end
            end
        end
    end
    return best,dist
end

-- Sora-style Force Hit and Body Lock, adapted to Snow's bat finder.
function Dragon.getBodyLockTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best,bestDistance=nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player~=LP and player.Character
        local target=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if target and hum and hum.Health>0 then
            local distance=(target.Position-root.Position).Magnitude
            local inRange=Dragon.bodyLockMode~="RADIUS" or distance<=math.clamp(tonumber(Dragon.bodyLockRange) or 60,1,500)
            if inRange and distance<bestDistance then best,bestDistance=target,distance end
        end
    end
    return best
end
function Dragon.setBodyLock(on)
    Dragon.bodyLock=on==true
    if Dragon.bodyLockConn then pcall(function() Dragon.bodyLockConn:Disconnect() end); Dragon.bodyLockConn=nil end
    if not Dragon.bodyLock then
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.AutoRotate=true end
        return
    end
    Dragon.bodyLockConn=RunService.Heartbeat:Connect(function()
        if not Dragon.bodyLock then return end
        local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        local target=Dragon.getBodyLockTarget()
        if not root or not hum or not target then if hum then hum.AutoRotate=true end; return end
        local flat=Vector3.new(target.Position.X-root.Position.X,0,target.Position.Z-root.Position.Z)
        if flat.Magnitude>.1 then
            -- Match Sora's Body Lock: rotate through angular velocity only.
            -- Reassigning CFrame here was forcing the character's physics
            -- while another player was nearby and could trigger ragdoll/death.
            hum.AutoRotate=false
            local cross=root.CFrame.LookVector:Cross(flat.Unit)
            local angular=root.AssemblyAngularVelocity
            root.AssemblyAngularVelocity=Vector3.new(angular.X,cross.Y*40,angular.Z)
        end
    end)
end
Dragon.forceHitCooldown=false
if Dragon.forceHitConn then pcall(function() Dragon.forceHitConn:Disconnect() end) end
Dragon.forceHitConn=RunService.Heartbeat:Connect(function()
    if not Dragon.forceHit then
        if Dragon.forceHitBodyLock then Dragon.forceHitBodyLock=false; Dragon.setBodyLock(false) end
        return
    end
    if autoBatEnabled or Dragon.tpBat then return end
    local target,distance=Dragon.closestRoot()
    if not target or distance>8 then
        if Dragon.forceHitBodyLock then Dragon.forceHitBodyLock=false; Dragon.setBodyLock(false) end
        return
    end
    if Dragon.forceHitCooldown then return end
    Dragon.forceHitCooldown=true
    if not Dragon.bodyLock then Dragon.setBodyLock(true); Dragon.forceHitBodyLock=true end
    pcall(function()
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local bat=Dragon.findBat()
        if bat and hum and bat.Parent~=char then hum:EquipTool(bat) end
        if bat then bat:Activate(); local event=bat:FindFirstChildWhichIsA("RemoteEvent"); if event then event:FireServer() end end
    end)
    task.delay(.25,function() Dragon.forceHitCooldown=false end)
end)

-- Snow TP Bat target validation and recovery state.
Dragon.tpState=Dragon.tpState or {samples={},targetPlayer=nil,lastPosition=nil,lastSafeCFrame=nil,lastSampleTime=0,recoverUntil=0,hitCooldown=false}
function Dragon.isFiniteVector(value)
    return value and value.X==value.X and value.Y==value.Y and value.Z==value.Z
        and math.abs(value.X)<1e7 and math.abs(value.Y)<1e7 and math.abs(value.Z)<1e7
end
function Dragon.inspectTPTarget(player,targetRoot,myRoot)
    if not player or not targetRoot or not targetRoot.Parent then return true,nil end
    local state=Dragon.tpState; local sample=state.samples[player] or {}; state.samples[player]=sample
    local now=tick(); local pos=targetRoot.Position; local vel=targetRoot.AssemblyLinearVelocity
    local destroyHeight=workspace.FallenPartsDestroyHeight or -500
    local voidFloor=math.max(destroyHeight+90,-50)
    local dt=sample.time and math.max(now-sample.time,1/240) or math.huge
    local delta=sample.position and (pos-sample.position) or Vector3.zero
    local invalidStep=sample.position~=nil and dt<0.4 and (delta.Magnitude>90 or math.abs(delta.Y)>38)
    local invalidVelocity=not Dragon.isFiniteVector(vel) or vel.Magnitude>650 or math.abs(vel.Y)>150
    local invalidPosition=not Dragon.isFiniteVector(pos) or pos.Y<=voidFloor or pos.Y>650 or (myRoot and (pos-myRoot.Position).Magnitude>4000)
    if invalidPosition or invalidVelocity or invalidStep then sample.suspiciousUntil=now+1.35
    elseif now>=(sample.suspiciousUntil or 0) then sample.safePosition=pos end
    sample.position=pos; sample.time=now
    return now<(sample.suspiciousUntil or 0),sample
end
function Dragon.closestSafeTPRoot(root)
    local state=Dragon.tpState
    local locked=state.targetPlayer
    if locked and locked.Parent==Players and locked.Character then
        local lockedRoot=locked.Character:FindFirstChild("HumanoidRootPart"); local lockedHum=locked.Character:FindFirstChildOfClass("Humanoid")
        if lockedRoot and lockedHum and lockedHum.Health>0 then return lockedRoot,locked end
    end
    local best,bestPlayer,bestDistance=nil,nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player~=LP and player.Character
        local target=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        if target and hum and hum.Health>0 then
            local suspicious,sample=Dragon.inspectTPTarget(player,target,root)
            local position=suspicious and sample and sample.safePosition or target.Position
            if position then
                local distance=(root.Position-position).Magnitude
                if distance<bestDistance then best,bestPlayer,bestDistance=target,player,distance end
            end
        end
    end
    state.targetPlayer=bestPlayer
    return best,bestPlayer
end
function Dragon.recoverTPBat(root,hum,target)
    local state=Dragon.tpState; local now=tick(); local position=root.Position; local velocity=root.AssemblyLinearVelocity
    local floor=math.max((workspace.FallenPartsDestroyHeight or -500)+80,-55)
    local dt=now-(state.lastSampleTime or now)
    local suddenDrop=state.lastPosition and dt<=0.35 and position.Y<state.lastPosition.Y-40
    local suddenRise=state.lastPosition and dt<=0.35 and position.Y>state.lastPosition.Y+25
    local unsafe=position.Y<=floor or position.Y>400 or suddenDrop or suddenRise or math.abs(velocity.Y)>90 or velocity.Magnitude>450
    if unsafe then
        local recovery=state.lastSafeCFrame
        if target and target.Parent and target.Position.Y>floor+10 and target.Position.Y<350 then recovery=CFrame.new(target.Position+Vector3.new(0,0.9,0)) end
        pcall(function()
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
            hum.PlatformStand=false; hum.Sit=false; hum.AutoRotate=true; hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            if recovery then root.CFrame=recovery end
        end)
        state.recoverUntil=now+0.55
    elseif now>=(state.recoverUntil or 0) and position.Y>floor+15 and math.abs(velocity.Y)<85 and position.Y<250 then
        state.lastSafeCFrame=root.CFrame
    end
    state.lastPosition=root.Position; state.lastSampleTime=now
    return now<(state.recoverUntil or 0)
end
function Dragon.tpHit()
    if Dragon.tpBatHittingCooldown then return end
    Dragon.tpBatHittingCooldown=true
    local version=Dragon.tpBatVersion or "V1"
    pcall(function()
        local char=LP.Character
        if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        local bat=Dragon.findBat()
        if not bat then return end
        if bat.Parent~=char and hum then pcall(function() hum:EquipTool(bat) end) end
        if autoSwingEnabled then
        local swings=version=="V2" and 1 or 3
            for _=1,swings do pcall(function() bat:Activate() end) end
            local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
            if version~="V2" then
                local rf=bat:FindFirstChildWhichIsA("RemoteFunction")
                if rf then pcall(function() rf:InvokeServer() end) end
            end
        end
    end)
    task.delay(version=="V2" and 0.08 or 0.045,function()
        Dragon.tpBatHittingCooldown=false
    end)
end

function Dragon_forceAimbotOff()
    autoBatEnabled=false
    if aimbotConn then pcall(function() aimbotConn:Disconnect() end); aimbotConn=nil end
    if stopBatAimbot then pcall(stopBatAimbot) end
    autoBatEnabled=false
    pcall(function()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        if GuiToggleSetters and GuiToggleSetters.circle then GuiToggleSetters.circle(false) end
    end)
end

function Dragon.isTPBatAntiDieEnabled()
    -- V2 and V3 always own their Anti Die protection.  V1 remains optional.
    return Dragon.tpBatAntiDie or Dragon.tpBatVersion=="V2" or Dragon.tpBatVersion=="V3"
end

function Dragon.bindTPBatAntiDie(character)
    Dragon.clearTPBatAntiDie()
    if not Dragon.tpBat or not Dragon.isTPBatAntiDieEnabled() or not character then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",3)
    if not humanoid then return end
    Dragon._tpAntiDieHumanoid=humanoid
    Dragon._tpAntiDieReviving=false
    pcall(function()
        humanoid.BreakJointsOnDeath=false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,false)
    end)
    Dragon._tpAntiDieConn=humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not Dragon.tpBat or not Dragon.isTPBatAntiDieEnabled() or not humanoid.Parent or humanoid.Health>0 or Dragon._tpAntiDieReviving then return end
        Dragon._tpAntiDieReviving=true
        pcall(function() humanoid.Health=humanoid.MaxHealth; humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false); humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        task.delay(.2,function() Dragon._tpAntiDieReviving=false end)
    end)
    Dragon._tpAntiDieDeathConn=humanoid.Died:Connect(function()
        if not Dragon.tpBat or not Dragon.isTPBatAntiDieEnabled() or not humanoid.Parent or Dragon._tpAntiDieReviving then return end
        Dragon._tpAntiDieReviving=true
        task.defer(function()
            if Dragon.tpBat and Dragon.isTPBatAntiDieEnabled() and character.Parent and humanoid.Parent then pcall(function() humanoid.Health=humanoid.MaxHealth; humanoid:ChangeState(Enum.HumanoidStateType.Running) end) end
            Dragon._tpAntiDieReviving=false
        end)
    end)
end

function Dragon.clearTPBatAntiDie()
    for _,key in ipairs({"_tpAntiDieConn","_tpAntiDieDeathConn"}) do
        if Dragon[key] then pcall(function() Dragon[key]:Disconnect() end); Dragon[key]=nil end
    end
    local humanoid=Dragon._tpAntiDieHumanoid
    if humanoid and humanoid.Parent then
        pcall(function()
            humanoid.BreakJointsOnDeath=true
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,true)
        end)
    end
    Dragon._tpAntiDieHumanoid=nil
end

function Dragon.prepareTPBatHumanoid(humanoid)
    if not humanoid then return end
    local state=Dragon.tpBatVoidState or {}; Dragon.tpBatVoidState=state
    if state.fallingDownEnabled==nil then
        pcall(function() state.fallingDownEnabled=humanoid:GetStateEnabled(Enum.HumanoidStateType.FallingDown) end)
        pcall(function() state.ragdollEnabled=humanoid:GetStateEnabled(Enum.HumanoidStateType.Ragdoll) end)
    end
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        humanoid.PlatformStand=false; humanoid.Sit=false; humanoid.AutoRotate=true
    end)
end

function Dragon.tpBatGuardVoid(root,humanoid)
    if not Dragon.tpBat or not root or not humanoid then return false end
    local state=Dragon.tpBatVoidState or {}; Dragon.tpBatVoidState=state
    local now=tick(); local position=root.Position; local velocity=root.AssemblyLinearVelocity
    local voidFloor=math.max((workspace.FallenPartsDestroyHeight or -500)+80,-55)
    local dt=now-(state.lastSampleTime or now)
    local suddenDrop=state.lastPosition and dt<=.35 and position.Y<state.lastPosition.Y-40
    local suddenRise=state.lastPosition and dt<=.35 and position.Y>state.lastPosition.Y+25
    local humState=humanoid:GetState()
    local ragdolled=humanoid.PlatformStand or humState==Enum.HumanoidStateType.Physics or humState==Enum.HumanoidStateType.Ragdoll or humState==Enum.HumanoidStateType.FallingDown
    local unsafe=position.Y<=voidFloor or position.Y>400 or suddenDrop or suddenRise or math.abs(velocity.Y)>90 or velocity.Magnitude>450 or ragdolled
    if unsafe then
        local safe=state.lastSafeCFrame
        pcall(function()
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
            humanoid.PlatformStand=false; humanoid.Sit=false; humanoid.AutoRotate=true
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            if safe then root.CFrame=safe end
        end)
        state.recoverUntil=now+.55
    elseif now>=(state.recoverUntil or 0) and position.Y>voidFloor+15 and position.Y<250 and math.abs(velocity.Y)<85 then
        state.lastSafeCFrame=root.CFrame
    end
    state.lastPosition=root.Position; state.lastSampleTime=now
    return now<(state.recoverUntil or 0)
end

-- TP Bat V6: direct V2 Violette flow, kept separate from Snow's other modes.
function Dragon.runTPBatV6()
    if not Dragon.tpBat or Dragon.tpBatVersion~="V6" then return end
    local character=LP.Character
    if not character then return end
    local root=character:FindFirstChild("HumanoidRootPart")
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    local animator=humanoid:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            local tracks=animator:GetPlayingAnimationTracks()
            for i=#tracks,1,-1 do tracks[i]:Stop() end
        end)
    end

    local bat=Dragon.findBat()
    if bat and bat.Parent~=character then pcall(function() humanoid:EquipTool(bat) end) end

    local target,closestDistance=nil,math.huge
    for _,player in pairs(Players:GetPlayers()) do
        if player~=LP and player.Character then
            local targetRoot=player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid=player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health>0 then
                local distance=(root.Position-targetRoot.Position).Magnitude
                if distance<closestDistance then closestDistance=distance; target=player end
            end
        end
    end
    if closestDistance>100 or not target or not target.Character then return end

    local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    if sethiddenproperty then pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",targetRoot) end) end
    local targetPosition=targetRoot.Position+Vector3.new(0,.9,0)
    if (root.Position-targetPosition).Magnitude>8 then root.CFrame=CFrame.new(targetPosition) end
    local camera=workspace.CurrentCamera
    if camera then camera.CFrame=CFrame.new(camera.CFrame.Position,targetRoot.Position) end

    if not Dragon.tpBatV6HittingCooldown then
        Dragon.tpBatV6HittingCooldown=true
        pcall(function()
            local activeBat=Dragon.findBat()
            if not activeBat then return end
            activeBat:Activate()
            local event=activeBat:FindFirstChildWhichIsA("RemoteEvent")
            if event then event:FireServer() end
        end)
        task.delay(.08,function() Dragon.tpBatV6HittingCooldown=false end)
    end

    pcall(function()
        for _,part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end)
end

function Dragon.startTPBat()
    -- Equivalent of the attached V2 isActionBlocked("tpbat") gate.
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
    if Dragon.clearExclusive then Dragon.clearExclusive("TP_BAT") end
    Dragon_forceAimbotOff()
    if Dragon.tpConn then pcall(function() Dragon.tpConn:Disconnect() end) end
    Dragon.clearTPBatAntiDie()
    if Dragon._tpCharConn then pcall(function() Dragon._tpCharConn:Disconnect() end) end
    Dragon.tpConn=nil; Dragon._tpAntiDieConn=nil; Dragon._tpCharConn=nil
    Dragon.tpBat=true
    Dragon.tpBatSpeedResumePending=false
    -- Global Anti Die / Anti Shield must never alter TP Bat movement.
    if Dragon.clearGlobalAntiDie then Dragon.clearGlobalAntiDie() end
    applyNoCamCollision()
    Dragon.bindTPBatAntiDie(LP.Character)
    Dragon._tpCharConn=LP.CharacterAdded:Connect(function(character)
        if Dragon.tpBat and Dragon.isTPBatAntiDieEnabled() then task.wait(.1); Dragon.bindTPBatAntiDie(character) end
    end)

    -- Snow TP Bat follow mode.
    Dragon.tpConn=RunService.Heartbeat:Connect(function(dt)
        if not Dragon.tpBat then return end
        -- Equivalent of V2's Safe Mode / isHoldingBrainrot safeguard.
        if Dragon.antiKick and SafeMode and SafeMode.holdingBrainrot and SafeMode.holdingBrainrot() then
            task.defer(function()
                if Dragon.tpBat then
                    Dragon.stopTPBat()
                    if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
                    if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                end
            end)
            return
        end
        local character=LP.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health<=0 then return end
        if Dragon.tpBatVersion=="V6" then Dragon.runTPBatV6(); return end
        if Dragon.tpBatAntiVoid and Dragon.tpBatGuardVoid(root,humanoid) then return end
        local target,targetPlayer,closestDistance=nil,nil,math.huge
        for _,player in ipairs(Players:GetPlayers()) do
            local otherCharacter=player~=LP and player.Character
            local otherHumanoid=otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
            local otherRoot=otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
            if otherRoot and otherHumanoid and otherHumanoid.Health>0 then
                local distance=(root.Position-otherRoot.Position).Magnitude
                if distance<closestDistance then target=otherRoot; targetPlayer=player; closestDistance=distance end
            end
        end
        Dragon.tpBatCurrentTarget=targetPlayer
        if not target then return end
        local version=Dragon.tpBatVersion or "V1"
        local center=target.Position+Vector3.new(0,.9,0)
        dt=math.clamp(tonumber(dt) or 1/60,.001,.1)
        local function snap(position,lookAt)
            root.CFrame=((position-lookAt).Magnitude>.001) and CFrame.new(position,lookAt) or CFrame.new(position)
            root.AssemblyLinearVelocity=Vector3.zero
        end
        pcall(function()
            if version=="V1" then
                if (root.Position-center).Magnitude>8 then root.CFrame=CFrame.new(center) end
            else
                local velocity=target.AssemblyLinearVelocity or Vector3.zero
                local flatVelocity=Vector3.new(velocity.X,0,velocity.Z)
                if flatVelocity.Magnitude>110 then flatVelocity=flatVelocity.Unit*110 end
                local predicted=center+flatVelocity*.05
                if version=="V2" then
                    Dragon.tpBatOrbitAngle=(Dragon.tpBatOrbitAngle or 0)+80*dt
                    local angle=Dragon.tpBatOrbitAngle
                    snap(predicted+Vector3.new(math.cos(angle)*4.2,0,math.sin(angle)*4.2),predicted)
                else
                    local look,right=target.CFrame.LookVector,target.CFrame.RightVector
                    local anchor=predicted
                    if version~="V3" and flatVelocity.Magnitude>.5 then anchor=predicted+flatVelocity.Unit*.5 end
                    if version=="V5" then
                        Dragon.tpBatOrbitAngle=(Dragon.tpBatOrbitAngle or 0)+60*dt*5
                        local angle=Dragon.tpBatOrbitAngle
                        for i=1,300 do
                            local t=i/300; local radius=1.5+(3-1.5)*math.abs(math.sin(t*math.pi*3)); local a=angle+t*12
                            snap(anchor+right*(math.cos(a)*radius)+look*(math.sin(a)*radius)+Vector3.new(0,math.sin(a*1.5)*.15),anchor)
                        end
                        snap(anchor+Vector3.new(0,.15,0),anchor+Vector3.new(math.sin(angle)*.3,.1,math.cos(angle)*.3))
                    else
                        Dragon.tpBatSpin=(Dragon.tpBatSpin or 0)+48*dt*4.4
                        local spin=Dragon.tpBatSpin; local c,s=math.cos(spin),math.sin(spin)
                        for i=1,300 do
                            local jx=((i%5)-2)*.05; local jz=((i%7)-3)*.04; local jy=((i%3)-1)*.025
                            local ox=jx*c-jz*s; local oz=jx*s+jz*c
                            snap(anchor+right*ox+look*(.12+oz)+Vector3.new(0,jy,0),anchor)
                        end
                        snap(anchor+Vector3.new(0,.15,0),anchor+Vector3.new(math.sin(spin)*.4,0,math.cos(spin)*.4))
                    end
                end
            end
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            local speedVelocity=root:FindFirstChild("FadedSpeedLV")
            if speedVelocity then speedVelocity.Enabled=false; speedVelocity.PlaneVelocity=Vector2.zero end
        end)
        local camera=workspace.CurrentCamera
        if camera and not Dragon.tpBatFreeCamera then camera.CFrame=CFrame.new(camera.CFrame.Position,target.Position) end
        Dragon.tpHit()
        local selectedHumanoid=target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        local state=selectedHumanoid and selectedHumanoid:GetState()
        local ragdolled=selectedHumanoid and (selectedHumanoid.PlatformStand or state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown)
        if targetPlayer~=Dragon.tpBatHitTarget then Dragon.tpBatHitTarget=targetPlayer; Dragon.tpBatHitTargetRagdolled=ragdolled
        elseif (Dragon.tpBatAutoDisableOnHit or Dragon.autoAfterDrop) and ragdolled and not Dragon.tpBatHitTargetRagdolled then
            Dragon.autoAfterDrop=false
            Dragon.stopTPBat(); if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end; if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
        else Dragon.tpBatHitTargetRagdolled=ragdolled end
    end)
end

function Dragon.stopTPBat()
    Dragon.tpBat=false
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if root and sethiddenproperty then pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",root) end) end
    applyNoCamCollision()
    if Dragon.tpConn then pcall(function() Dragon.tpConn:Disconnect() end); Dragon.tpConn=nil end
    Dragon.clearTPBatAntiDie()
    if Dragon._tpCharConn then pcall(function() Dragon._tpCharConn:Disconnect() end); Dragon._tpCharConn=nil end
    Dragon.tpBatCurrentTarget=nil
    Dragon.tpBatHittingCooldown=false
    Dragon.tpBatV6HittingCooldown=false
    Dragon.tpBatHitTarget=nil; Dragon.tpBatHitTargetRagdolled=false; Dragon.tpBatSpin=0
    Dragon.autoAfterDrop=false
    Dragon.tpBatSpeedResumePending=true
    Dragon.tpBatSpeedResumeAt=tick()+0.45
    if antiDieEnabled and Dragon.setGlobalAntiDie then Dragon.setGlobalAntiDie(true) end
    if Dragon.tpState then Dragon.tpState.targetPlayer=nil; Dragon.tpState.lastSafeCFrame=nil; Dragon.tpState.recoverUntil=0 end
    -- Release TP Bat's physics cleanly before the normal Speed engine resumes.
    task.defer(function()
        local character=LP.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health>0 then
            pcall(function()
                humanoid.PlatformStand=false; humanoid.Sit=false; humanoid.AutoRotate=true
                local state=humanoid:GetState()
                if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
                if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
            end)
        end
        if not Dragon.tpBat and snowEnsureVelocity then pcall(snowEnsureVelocity) end
    end)
end
-- TP Bat: Message (19) network-owner implementation, adapted to Snow's hooks.
Dragon.tpBatMaxRange=100
function Dragon.startTPBat()
    if Dragon.tpConn then return end
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
    if Dragon.clearExclusive then Dragon.clearExclusive("TP_BAT") end
    Dragon_forceAimbotOff()
    Dragon.tpBat=true
    Dragon.tpBatHittingCooldown=false
    Dragon.tpBatCurrentTarget=nil
    Dragon.tpConn=RunService.Heartbeat:Connect(function()
        if not Dragon.tpBat then return end
        local character=LP.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        if humanoid.Health<=0 then return end

        local animator=humanoid:FindFirstChildOfClass("Animator")
        if animator then
            pcall(function()
                for _,track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
            end)
        end

        local bat=Dragon.findBat()
        if bat and bat.Parent~=character then pcall(function() humanoid:EquipTool(bat) end) end

        local target,targetPlayer,closestDistance=nil,nil,math.huge
        for _,player in ipairs(Players:GetPlayers()) do
            local targetCharacter=player~=LP and player.Character
            local targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            local targetHumanoid=targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health>0 then
                local distance=(targetRoot.Position-root.Position).Magnitude
                if distance<closestDistance then
                    closest,targetPlayer,closestDistance=targetRoot,player,distance
                end
            end
        end
        Dragon.tpBatCurrentTarget=targetPlayer
        if not target or closestDistance>Dragon.tpBatMaxRange then return end

        -- SetNetworkOwner is server-only in normal LocalScripts. Try it when
        -- available, but never wait/yield or depend on it for the local TP.
        pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(nil) end end)
        if not Dragon.tpBat or root.Parent~=character or target.Parent==nil then return end
        root.CFrame=CFrame.new(target.Position+Vector3.new(0,0.9,0))
        root.AssemblyLinearVelocity=target.AssemblyLinearVelocity
        root.AssemblyAngularVelocity=Vector3.zero
        pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)

        local camera=workspace.CurrentCamera
        if camera and not Dragon.tpBatFreeCamera then camera.CFrame=CFrame.new(camera.CFrame.Position,target.Position) end
        if not Dragon.tpBatHittingCooldown then
            Dragon.tpBatHittingCooldown=true
            pcall(function()
                local activeBat=Dragon.findBat()
                if not activeBat then return end
                activeBat:Activate()
                local remote=activeBat:FindFirstChildWhichIsA("RemoteEvent")
                if remote then remote:FireServer() end
            end)
            task.delay(0.08,function() Dragon.tpBatHittingCooldown=false end)
        end
        pcall(function()
            for _,part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end)
    end)
end
function Dragon.stopTPBat()
    Dragon.tpBat=false
    if Dragon.tpConn then pcall(function() Dragon.tpConn:Disconnect() end); Dragon.tpConn=nil end
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) end
    Dragon.tpBatCurrentTarget=nil
    Dragon.tpBatHittingCooldown=false
end

function Dragon.v2Swing()
    -- same pace as aimbot auto-swing
    local now=tick()
    if now-(batV2LastSwing or 0)<0.05 then return end
    batV2LastSwing=now
    Dragon.v2CD=true
    pcall(function()
        local c=LP.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local bat=Dragon.findBat()
        if not bat then return end
        if bat.Parent~=c and h then pcall(function() h:EquipTool(bat) end) end
        pcall(function() bat:Activate() end)
        local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then pcall(function() ev:FireServer() end) end
        task.defer(function()
            if bat and bat.Parent then pcall(function() bat:Activate() end) end
        end)
    end)
    task.delay(0.05,function() Dragon.v2CD=false end)
end

function Dragon.stopBatV2()
    batV2Enabled=false
    Dragon.batV2=false
    if batV2Conn then pcall(function() batV2Conn:Disconnect() end); batV2Conn=nil end
    if Dragon.v2Conn then pcall(function() Dragon.v2Conn:Disconnect() end); Dragon.v2Conn=nil end
    local c=LP.Character
    if c then
        local r=c:FindFirstChild("HumanoidRootPart")
        local h=c:FindFirstChildOfClass("Humanoid")
        if r then r.AssemblyLinearVelocity=Vector3.zero; r.AssemblyAngularVelocity=Vector3.zero end
        if h then h.AutoRotate=true end
    end
    pcall(function()
        if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end
    end)
end

function Dragon.startBatV2()
    -- Snow Anti Bat / BAT V2 (pasted aimbot logic, speed-only tunable)
    if batV2Conn then pcall(function() batV2Conn:Disconnect() end); batV2Conn=nil end
    -- turn off competing modes
    pcall(function()
        if Dragon.tpBat and Dragon.stopTPBat then Dragon.stopTPBat() end
        if autoBatEnabled and stopBatAimbot then stopBatAimbot() end
        if autoLeftEnabled then autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end end
        if autoRightEnabled then autoRightEnabled=false; if stopAutoRight then stopAutoRight() end end
    end)
    batV2Enabled=true
    Dragon.batV2=true
    local MAX_TURN_RATE=28
    local DISTANCE=-1
    local HEIGHT=1.3
    local V_OFFSET=1
    batV2Conn=RunService.Heartbeat:Connect(function()
        if not batV2Enabled or not Dragon.batV2 then return end
        local c=LP.Character; if not c then return end
        local h=c:FindFirstChildOfClass("Humanoid")
        local r=c:FindFirstChild("HumanoidRootPart")
        if not h or not r then return end
        if not h.AutoRotate then h.AutoRotate=true end
        -- equip bat
        if not c:FindFirstChildOfClass("Tool") then
            local bat=Dragon.findBat()
            if bat then pcall(function() h:EquipTool(bat) end) end
        end
        local target=Dragon.closestRoot()
        if target then
            local aimPos=target.Position+Vector3.new(0,V_OFFSET,0)
            h.AutoRotate=false
            local look=aimPos-r.Position
            local flat=Vector3.new(look.X,0,look.Z)
            if look.Magnitude>0.01 and flat.Magnitude>0.01 then
                local yaw=math.deg(math.atan2(-flat.X,-flat.Z))
                local delta=(yaw-r.Orientation.Y+180)%360-180
                local rate=math.clamp(delta*8,-MAX_TURN_RATE,MAX_TURN_RATE)
                r.AssemblyAngularVelocity=Vector3.new(0,rate,0)
            else
                r.AssemblyAngularVelocity=Vector3.zero
            end
            local dir=look.Unit
            local stand=aimPos-dir*DISTANCE+Vector3.new(0,HEIGHT,0)
            local move=stand-r.Position
            local hDir=Vector3.new(move.X,0,move.Z)
            -- Legacy entry path: read the same two live BYPASS values as the
            -- replacement loop, including the active Lagger mode.
            local speed
            if dragonSpeed then
                speed=dragonSpeed("BYPASS")
            else
                speed=math.clamp(tonumber(laggerModeEnabled and BYPASS_LAGGER_AIMBOT_SPEED or BYPASS_AIMBOT_SPEED) or tonumber(batV2Speed) or 56.5,1,200)
            end
            local vertSpeed=speed
            local hVel=hDir.Magnitude>0.1 and hDir.Unit*speed or Vector3.zero
            local vVel=Vector3.new(0,math.clamp(move.Y*3,-vertSpeed,vertSpeed),0)
            r.AssemblyLinearVelocity=hVel+vVel
            if hDir.Magnitude>0.5 then h:Move(hDir.Unit,false) end
            -- keep auto swing like aimbot (always while on target)
            Dragon.v2Swing()
        else
            h.AutoRotate=true
            r.AssemblyAngularVelocity=Vector3.zero
            Dragon.v2Swing()
        end
    end)
    Dragon.v2Conn=batV2Conn
    pcall(function()
        if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(true) end
    end)
end

function Dragon.toggleBatV2()
    if batV2Enabled or Dragon.batV2 then
        Dragon.stopBatV2()
    else
        if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
            pcall(function() if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end end)
            return
        end
        Dragon.startBatV2()
    end
    saveConfig()
end

-- SNOW.VS aimbot replacement: Normal (AIMBOT) and Anti Bypass (BYPASS).
-- This replaces both legacy Snow combat loops while retaining Snow's UI/config hooks.
AIMBOT_SPEED=AIMBOT_SPEED or 58
LAGGER_AIMBOT_SPEED=LAGGER_AIMBOT_SPEED or 40
BYPASS_AIMBOT_SPEED=BYPASS_AIMBOT_SPEED or 58
BYPASS_LAGGER_AIMBOT_SPEED=BYPASS_LAGGER_AIMBOT_SPEED or 40
aimbotMode=aimbotMode or "AIMBOT"
aimbotNormalVersion=aimbotNormalVersion or "V1"
aimbotBypassVersion=aimbotBypassVersion or "V1"
DragonAimbot=DragonAimbot or {conn=nil,swingCooldown=false,mode=nil,stopAfterHit=false}
function dragonFindBat()
    local char=LP.Character; if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local pack=LP:FindFirstChildOfClass("Backpack")
    if pack then for _,tool in ipairs(pack:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
function dragonClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil,math.huge end
    local closest,distance=nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        local char=player~=LP and player.Character
        local target=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        if target and hum and hum.Health>0 then local d=(target.Position-root.Position).Magnitude; if d<distance then closest,distance=target,d end end
    end
    return closest,distance
end
function dragonSpeed(mode)
    local lagger=(laggerModeEnabled==true)
    if mode=="BYPASS" then
        return math.clamp(tonumber(lagger and BYPASS_LAGGER_AIMBOT_SPEED or BYPASS_AIMBOT_SPEED) or 58,1,200)
    end
    return math.clamp(tonumber(lagger and LAGGER_AIMBOT_SPEED or AIMBOT_SPEED) or 58,1,200)
end
function snowGetAimbotVersion(mode)
    if mode=="BYPASS" then
        if aimbotBypassVersion=="V2" or aimbotBypassVersion=="V3" then return aimbotBypassVersion end
        return "V1"
    end
    if aimbotNormalVersion=="V2" or aimbotNormalVersion=="V3" then return aimbotNormalVersion end
    return "V1"
end
function snowSetAimbotSpeed(slot,value)
    local speed=math.clamp(tonumber(value) or 58,1,200)
    if slot=="AIMBOT" then
        AIMBOT_SPEED=speed
    elseif slot=="AIMBOT_LAGGER" then
        LAGGER_AIMBOT_SPEED=speed
    elseif slot=="BYPASS" then
        BYPASS_AIMBOT_SPEED=speed; batV2Speed=speed
    elseif slot=="BYPASS_LAGGER" then
        BYPASS_LAGGER_AIMBOT_SPEED=speed; batV2Speed=speed
    end
end
function dragonStopAimbot()
    if DragonAimbot.conn then pcall(function() DragonAimbot.conn:Disconnect() end); DragonAimbot.conn=nil end
    -- Ensure an old BAT V2 connection can never keep moving the character
    -- with its obsolete single-speed value.
    if batV2Conn then pcall(function() batV2Conn:Disconnect() end); batV2Conn=nil end
    DragonAimbot.swingCooldown=false; DragonAimbot.stopAfterHit=false; DragonAimbot.mode=nil; autoBatEnabled=false; batV2Enabled=false; Dragon.batV2=false
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
    if root then
        local dragonMover=root:FindFirstChild("SnowDragonBypassV3Velocity")
        local dragonAttachment=root:FindFirstChild("SnowDragonBypassV3Attachment")
        if dragonMover then pcall(function() dragonMover:Destroy() end) end
        if dragonAttachment then pcall(function() dragonAttachment:Destroy() end) end
        root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
    end
    if hum then hum.AutoRotate=true; pcall(function() hum:Move(Vector3.zero,false) end) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
-- Normal Aimbot V3: separate, discontinuity-safe horizontal and vertical prediction.
-- Cache local Data Ping; reading Stats every render frame causes unnecessary jitter.
Dragon.aimbotPingCache=Dragon.aimbotPingCache or {value=0,updated=0}
function Dragon.getAimbotPingSeconds(now)
    local cache=Dragon.aimbotPingCache
    if now-(cache.updated or 0)>.45 then
        local ping=0
        pcall(function()
            local item=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local text=item and item:GetValueString() or ""
            ping=tonumber(text:match("[%d%.]+")) or 0
        end)
        cache.value=math.clamp(ping/1000,0,.22); cache.updated=now
    end
    return cache.value or 0
end
Dragon.normalAimbotSamples=Dragon.normalAimbotSamples or {}
function Dragon.stepNormalAimbotV3(root,hum,target,distance,dt)
    local now=tick()
    local sample=Dragon.normalAimbotSamples[target]
    local targetPosition=target.Position
    local reportedVelocity=target.AssemblyLinearVelocity
    local flatVelocity=Vector3.new(reportedVelocity.X,0,reportedVelocity.Z)
    local verticalVelocity=0
    local rejectPrediction=false
    if sample then
        local elapsed=math.clamp(now-sample.time,1/120,.25)
        local delta=targetPosition-sample.position
        local measured=delta/elapsed
        local flatMeasured=Vector3.new(measured.X,0,measured.Z)
        -- TP Down and jump impulses must never become lead velocity. Keep the
        -- last stable horizontal estimate for a short settling window instead.
        local discontinuity=flatMeasured.Magnitude>145 or math.abs(measured.Y)>105
            or Vector3.new(delta.X,0,delta.Z).Magnitude>28 or math.abs(delta.Y)>18
        -- Jitter measures disagreement between the observed displacement and
        -- the last trusted velocity. It separates normal turns from lag warps.
        local expected=sample.flatVelocity*elapsed
        local residual=(Vector3.new(delta.X,0,delta.Z)-expected).Magnitude
        sample.jitter=(sample.jitter or 0)*.68+residual*.32
        if discontinuity then
            sample.rejectUntil=now+.18
        elseif now>=(sample.rejectUntil or 0) then
            flatMeasured=flatMeasured.Magnitude>120 and flatMeasured.Unit*120 or flatMeasured
            local blend=sample.jitter>5 and .34 or .64
            sample.flatVelocity=sample.flatVelocity:Lerp(flatMeasured,blend)
            -- Vertical motion is tracked only for stabilization, never led.
            sample.verticalVelocity=sample.verticalVelocity*.65+math.clamp(measured.Y,-55,55)*.35
        end
        sample.position=targetPosition; sample.time=now
        flatVelocity=sample.flatVelocity
        verticalVelocity=(now>=(sample.rejectUntil or 0)) and sample.verticalVelocity or 0
        rejectPrediction=now<(sample.rejectUntil or 0)
    else
        Dragon.normalAimbotSamples[target]={position=targetPosition,time=now,flatVelocity=Vector3.new(reportedVelocity.X,0,reportedVelocity.Z),verticalVelocity=0,rejectUntil=0,jitter=0}
    end
    local myPosition=root.Position
    local pingSeconds=Dragon.getAimbotPingSeconds(now)
    local baseLead=.10+distance/math.max(dragonSpeed("AIMBOT"),1)*.20
    -- Stable movement gets a bounded local-ping compensation. On high target
    -- jitter, favor re-acquisition over a long prediction into stale space.
    local jitter=sample and (sample.jitter or 0) or 0
    local stability=math.clamp(1-jitter/12,.30,1)
    local leadTime=math.clamp((baseLead+pingSeconds*.72)*stability,.08,.38)
    if rejectPrediction then leadTime=0 end
    local predicted=targetPosition+flatVelocity*leadTime+target.CFrame.LookVector*.28
    local direction=predicted-myPosition
    local flatDirection=Vector3.new(direction.X,0,direction.Z)
    flatDirection=flatDirection.Magnitude<.05 and root.CFrame.LookVector or flatDirection.Unit
    local chaseSpeed=dragonSpeed("AIMBOT")
    local desiredHeight=targetPosition.Y+3.7
    -- Do not lead Y: jump and TP-Down velocities are intentionally excluded.
    local verticalCommand=(desiredHeight-myPosition.Y)*20+verticalVelocity*.12
    if hum.FloorMaterial~=Enum.Material.Air then verticalCommand=math.max(verticalCommand,13) end
    verticalCommand=math.clamp(verticalCommand,-70,110)
    local desiredVelocity=Vector3.new(flatDirection.X*chaseSpeed,verticalCommand,flatDirection.Z*chaseSpeed)
    root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVelocity,.8)
    local predictTime=rejectPrediction and 0 or math.min(leadTime,math.clamp(flatVelocity.Magnitude/135+pingSeconds*.45,.06,.30))
    local lookAt=targetPosition+flatVelocity*predictTime
    if (lookAt-myPosition).Magnitude>.1 then
        local delta=root.CFrame:Inverse()*CFrame.lookAt(myPosition,lookAt)
        local x,y,z=delta:ToEulerAnglesXYZ()
        root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(x,-2.5,2.5)*42,math.clamp(y,-2.5,2.5)*42,math.clamp(z,-2.5,2.5)*42))
    end
end
-- K7 normal Aimbot V2: latency prediction plus a small PID-style horizontal
-- correction.  It is isolated so Snow's V1/V3 and Bypass versions remain intact.
function Dragon.stepK7AimbotV2(root,hum,target,distance)
    local targetVelocity=target.AssemblyLinearVelocity
    local myPosition,targetPosition=root.Position,target.Position
    local predicted=targetPosition+targetVelocity*.14+target.CFrame.LookVector*.3
    local direction=predicted-myPosition
    local flatDirection=Vector3.new(direction.X,0,direction.Z)
    flatDirection=flatDirection.Magnitude<.05 and root.CFrame.LookVector or flatDirection.Unit

    local chaseSpeed=dragonSpeed("AIMBOT")
    local desiredHeight=targetPosition.Y+3.7
    local verticalVelocity=(desiredHeight-myPosition.Y)*19.5+targetVelocity.Y*.8
    if hum.FloorMaterial~=Enum.Material.Air then verticalVelocity=math.max(verticalVelocity,13) end
    verticalVelocity=math.clamp(verticalVelocity,-70,110)
    local desiredVelocity=Vector3.new(flatDirection.X*chaseSpeed,verticalVelocity,flatDirection.Z*chaseSpeed)
    root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVelocity,.8)

    local predictTime=math.clamp(targetVelocity.Magnitude/150,.05,.2)
    local lookAt=targetPosition+targetVelocity*predictTime
    if (lookAt-myPosition).Magnitude>.1 then
        local delta=root.CFrame:Inverse()*CFrame.lookAt(myPosition,lookAt)
        local x,y,z=delta:ToEulerAnglesXYZ()
        root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(x,-2.5,2.5)*42,math.clamp(y,-2.5,2.5)*42,math.clamp(z,-2.5,2.5)*42))
    end
end-- Dragon Bypass V3: adaptive target sampling plus a Vector LinearVelocity mover.
Dragon.dragonBypassSamples=Dragon.dragonBypassSamples or {}
function Dragon.stepDragonBypassV3(root,hum,target,dt)
    local now=tick()
    local sample=Dragon.dragonBypassSamples[target]
    local targetVelocity=target.AssemblyLinearVelocity
    if sample then
        local elapsed=math.clamp(now-sample.time,1/120,.25)
        local measured=(target.Position-sample.position)/elapsed
        if measured.Magnitude>80 then measured=measured.Unit*80 end
        targetVelocity=sample.velocity:Lerp(measured,.25)
        sample.position=target.Position; sample.time=now; sample.velocity=targetVelocity
    else
        sample={position=target.Position,time=now,velocity=targetVelocity}
        Dragon.dragonBypassSamples[target]=sample
    end
    local lead=target.Position+targetVelocity*math.clamp(targetVelocity.Magnitude/130,.05,.12)+Vector3.new(0,1,0)
    local lookOffset=lead-root.Position
    local lookFlat=Vector3.new(lookOffset.X,0,lookOffset.Z)
    if lookFlat.Magnitude>.01 then
        local yaw=(math.deg(math.atan2(-lookFlat.X,-lookFlat.Z))-root.Orientation.Y+180)%360-180
        local pitch=(math.deg(math.atan2(lookOffset.Y,lookFlat.Magnitude))-root.Orientation.X+180)%360-180
        local pitchAxis=Vector3.new(math.cos(math.rad(root.Orientation.Y)),0,-math.sin(math.rad(root.Orientation.Y)))
        root.AssemblyAngularVelocity=Vector3.new(0,math.clamp(math.rad(yaw)*285,-28,28),0)+pitchAxis*math.clamp(math.rad(pitch)*285,-28,28)
    end
    local standPoint=lead+lookOffset.Unit*2.8+Vector3.new(0,4.75,0)
    local offset=standPoint-root.Position
    local horizontal=Vector3.new(offset.X,0,offset.Z)
    local speed=dragonSpeed("BYPASS")
    local desired=(horizontal.Magnitude>.1 and horizontal.Unit*speed or Vector3.zero)+Vector3.new(0,math.abs(offset.Y)>.1 and math.sign(offset.Y)*52 or -2,0)
    local attachment=root:FindFirstChild("SnowDragonBypassV3Attachment")
    if not attachment then attachment=Instance.new("Attachment"); attachment.Name="SnowDragonBypassV3Attachment"; attachment.Parent=root end
    local mover=root:FindFirstChild("SnowDragonBypassV3Velocity")
    if not mover then
        mover=Instance.new("LinearVelocity"); mover.Name="SnowDragonBypassV3Velocity"; mover.Attachment0=attachment; mover.RelativeTo=Enum.ActuatorRelativeTo.World
        mover.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector; mover.ForceLimitsEnabled=true; mover.ForceLimitMode=Enum.ForceLimitMode.PerAxis; mover.Parent=root
    end
    mover.Attachment0=attachment
    local force=math.clamp(root.AssemblyMass*math.max(speed*220,6000),1000000,50000000)
    mover.MaxAxesForce=Vector3.new(force,force,force); mover.Enabled=true
    local alpha=1-math.exp(-math.max(dt or 1/60,0)*26)
    mover.VectorVelocity=mover.VectorVelocity:Lerp(desired,alpha)
    if horizontal.Magnitude>.5 then hum:Move(horizontal.Unit,false) end
end
function dragonStartAimbot(mode)
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return false end
    if Dragon.clearExclusive then Dragon.clearExclusive("AIMBOT") end
    dragonStopAimbot(); aimbotMode=mode; DragonAimbot.mode=mode
    if refreshMobileAimbotName then refreshMobileAimbotName() end
    if mode=="BYPASS" then batV2Enabled=true; Dragon.batV2=true else autoBatEnabled=true end
    if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
    if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
    local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if hum0 then hum0.AutoRotate=false end
    DragonAimbot.conn=RunService.RenderStepped:Connect(function(dt)
        local active=(mode=="BYPASS") and batV2Enabled or autoBatEnabled
        if not active or DragonAimbot.mode~=mode then return end
        local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not char or not root or not hum then return end
        local equippedTool=char:FindFirstChildOfClass("Tool")
        if equippedTool then
            local toolName=equippedTool.Name:lower()
            if toolName:find("medusa") or toolName:find("head") or toolName:find("stone") then
                -- Medusa owns the tool until its cast completes.  Do not let
                -- aimbot movement or auto-swing consume its activation.
                root.AssemblyLinearVelocity=Vector3.zero
                root.AssemblyAngularVelocity=Vector3.zero
                return
            end
        end
        local bat=equippedTool or dragonFindBat(); if bat and bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
        local target,distance=dragonClosestTarget()
        if not target then
            local mover=root:FindFirstChild("SnowDragonBypassV3Velocity")
            if mover then pcall(function() mover:Destroy() end) end
            local attachment=root:FindFirstChild("SnowDragonBypassV3Attachment")
            if attachment then pcall(function() attachment:Destroy() end) end
            root.AssemblyAngularVelocity=Vector3.zero
            return
        end
        local myPos,targetPos=root.Position,target.Position; local targetVelocity=target.AssemblyLinearVelocity
        local version=snowGetAimbotVersion(mode)
        -- V1 is Snow's original route; V2 is K7's route and V3 is the
        -- restored Normal V3 prediction route.
        local usedK7V2=(version=="V2" and mode=="AIMBOT")
        local usedNormalV3=(version=="V3" and mode=="AIMBOT")
        local usedDragonV3=(version=="V3" and mode=="BYPASS")
        if usedK7V2 then Dragon.stepK7AimbotV2(root,hum,target,distance) end
        if usedNormalV3 then Dragon.stepNormalAimbotV3(root,hum,target,distance,dt) end
        if usedDragonV3 then Dragon.stepDragonBypassV3(root,hum,target,dt) end
        if not usedK7V2 and not usedNormalV3 and not usedDragonV3 then
        local aimPos
        if version=="V2" then
            -- Ambitious Bypass V1 chases the live position directly.
            aimPos=(mode=="BYPASS") and targetPos or (targetPos+targetVelocity*.14+target.CFrame.LookVector*.3)
        elseif version=="V3" then
            -- Yout normal aimbot: lead the target's motion and look direction.
            aimPos=targetPos+targetVelocity*.14+target.CFrame.LookVector*.3
        else
            aimPos=mode=="AIMBOT" and (targetPos+targetVelocity*.14+target.CFrame.LookVector*.3) or targetPos
        end
        local direction=aimPos-myPos; local flat=Vector3.new(direction.X,0,direction.Z); if flat.Magnitude<0.01 then return end; flat=flat.Unit
        local vertical
        if version=="V2" then
            vertical=(targetPos.Y+3.7-myPos.Y)*19.5+(mode=="BYPASS" and 0 or targetVelocity.Y*.8)
            if hum.FloorMaterial~=Enum.Material.Air then vertical=math.max(vertical,13) end
        elseif version=="V3" then
            -- Match Yout's grounded lift and vertical velocity prediction.
            vertical=(targetPos.Y+3.7-myPos.Y)*19.5+targetVelocity.Y*.8
            if hum.FloorMaterial~=Enum.Material.Air then vertical=math.max(vertical,13) end
        else
            vertical=(targetPos.Y+3.7-myPos.Y)*19.5+(mode=="AIMBOT" and targetVelocity.Y*.8 or 0)
            if hum.FloorMaterial~=Enum.Material.Air then vertical=math.max(vertical,13) end
        end
        vertical=math.clamp(vertical,-70,110)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(Vector3.new(flat.X*dragonSpeed(mode),vertical,flat.Z*dragonSpeed(mode)),0.8)
        local facing
        if version=="V3" then
            -- Match Yout's rotation prediction independently from movement lead.
            facing=targetPos+targetVelocity*math.clamp(targetVelocity.Magnitude/150,.05,.2)
        else
            facing=(version=="V2" and mode=="BYPASS") and targetPos or ((version=="V2" or mode=="AIMBOT") and (targetPos+targetVelocity*math.clamp(targetVelocity.Magnitude/150,.05,.2)) or targetPos)
        end
        if (facing-myPos).Magnitude>0.1 then
            local rx,ry,rz=(root.CFrame:Inverse()*CFrame.lookAt(myPos,facing)):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(rx,-2.5,2.5)*42,math.clamp(ry,-2.5,2.5)*42,math.clamp(rz,-2.5,2.5)*42))
        end
        end
        if autoSwingEnabled and bat and (mode=="AIMBOT" or version=="V2" or version=="V3" or distance<=8) and not DragonAimbot.swingCooldown then
            local stopAfterHit=DragonAimbot.stopAfterHit==true
            local targetHum=target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            local targetHealth=targetHum and targetHum.Health or nil
            DragonAimbot.swingCooldown=true; pcall(function() bat:Activate() end)
            if stopAfterHit then
                -- V2 is a counter, but a swing that misses must not consume it.
                -- Stop only once the tracked opponent actually takes the hit.
                task.delay(0.18,function()
                    if not (DragonAimbot and DragonAimbot.stopAfterHit) then return end
                    local state=targetHum and targetHum:GetState()
                    local hit=targetHum and (targetHum.Health<(targetHealth or targetHum.Health)
                        or targetHum.PlatformStand==true
                        or state==Enum.HumanoidStateType.Physics
                        or state==Enum.HumanoidStateType.Ragdoll
                        or state==Enum.HumanoidStateType.FallingDown)
                    if hit then dragonStopAimbot()
                    else DragonAimbot.swingCooldown=false end
                end)
            else
                task.delay((mode=="BYPASS" and version=="V1") and .35 or .08,function() if DragonAimbot then DragonAimbot.swingCooldown=false end end)
            end
        end
    end)
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
    if autoBatSetVisual then autoBatSetVisual(true) end
    return true
end

-- Aimbot, TP Bat, Auto Left and Auto Right are a single exclusive movement
-- group. Starting one always stops the other three and refreshes their UI.
function Dragon.clearExclusive(except)
    if except~="AIMBOT" and (autoBatEnabled or batV2Enabled or Dragon.batV2) then
        dragonStopAimbot()
    end
    if except~="TP_BAT" and Dragon.tpBat then
        Dragon.stopTPBat()
        if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
        if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    end
    if except~="AUTO_LEFT" and autoLeftEnabled then
        autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    end
    if except~="AUTO_RIGHT" and autoRightEnabled then
        autoRightEnabled=false; if stopAutoRight then stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    end
end
startBatAimbot=function() return dragonStartAimbot("AIMBOT") end
stopBatAimbot=dragonStopAimbot
queueAutoBatStart=function() return dragonStartAimbot("AIMBOT") end
function snowSetBypassAimbot(on)
    aimbotMode="BYPASS"
    if on then return dragonStartAimbot("BYPASS") end
    return dragonStopAimbot()
end
Dragon.startBatV2=function() return snowSetBypassAimbot(true) end
Dragon.stopBatV2=function() return snowSetBypassAimbot(false) end
runAutoAfterDrop=function()
    if not autoAfterDropEnabled or not autoAfterDropWasCarrying then return end
    autoAfterDropWasCarrying=false
    task.delay(0.08,function()
        if not autoAfterDropEnabled or dropActive then return end
        if autoAfterDropMode=="TP_BAT" then
            -- Keeps the TP Bat version already selected by the player.
            Dragon.autoAfterDrop=true
            Dragon.startTPBat()
            if Dragon.setTPBatVisual then Dragon.setTPBatVisual(true) end
            if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
        else
            -- Keeps the selected Aimbot / Bypass mode and consumes itself on hit.
            local started
            if aimbotMode=="BYPASS" then started=Dragon.startBatV2() else started=startBatAimbot() end
            if started and DragonAimbot then DragonAimbot.stopAfterHit=true end
        end
    end)
end
Dragon.toggleBatV2=function()
    snowSetBypassAimbot(not (batV2Enabled or (DragonAimbot and DragonAimbot.mode=="BYPASS")))
    saveConfig()
end

-- MOBILE BUTTONS  (Dragon stack-button style)
-- ============================================================

-- Remove the obsolete screen-level Discord link left by older Snow versions.
pcall(function()
    for _,parent in ipairs({game:GetService("CoreGui"),LP:FindFirstChild("PlayerGui")}) do
        local old=parent and parent:FindFirstChild("SnowDiscordLink")
        if old then old:Destroy() end
    end
end)

function destroyMobileButtons()
    if mobGuiRef then
        pcall(function()
            mobGuiRef.Enabled=false
            for _,d in ipairs(mobGuiRef:GetDescendants()) do
                if d:IsA("GuiObject") then
                    d.Active=false
                    if d:IsA("GuiButton") then d.Visible=false end
                end
            end
            mobGuiRef:Destroy()
        end)
        mobGuiRef=nil
    end
    for _,n in ipairs({"DragonMobileButtons","SpectrumMobileButtons","SnowMobileButtons"}) do
        pcall(function()
            local cg=game:GetService("CoreGui")
            local old=cg:FindFirstChild(n)
            if old then old:Destroy() end
            local pgui=LP:FindFirstChild("PlayerGui")
            if pgui then local o=pgui:FindFirstChild(n); if o then o:Destroy() end end
        end)
    end
    mobBtnRefs={}
    -- restore camera control after GUI tear-down
    pcall(function()
        local cam=workspace.CurrentCamera
        if cam then
            if cam.CameraType==Enum.CameraType.Scriptable then
                cam.CameraType=Enum.CameraType.Custom
            end
        end
        UIS.MouseIconEnabled=true
        pcall(function() UIS.ModalEnabled=false end)
    end)
end
function buildMobileButtons()
    if not Dragon_INTRO_DONE then
        if not Dragon_MOBILE_QUEUED then
            Dragon_MOBILE_QUEUED=true
            dragonAfterIntro(function() Dragon_MOBILE_QUEUED=false; buildMobileButtons() end)
        end
        return
    end
    destroyMobileButtons(); if not mobileButtonsEnabled then return end
    -- preload shared logo asset for buttons
    task.spawn(function()
        pcall(function()
            loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "dragon_menu_logo.png")
        end)
    end)

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "DragonMobileButtons"; mobGui.ResetOnSpawn = false; mobGui.DisplayOrder = 5000; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then mobGui.Parent = LP:WaitForChild("PlayerGui") end
    mobGuiRef = mobGui

    -- ===== Noxa-style ROUND mobile buttons (56x56, soft rounded corners) =====
    local szMul = math.clamp((tonumber(mobileButtonsSize) or 80) / 80, 0.55, 1.6)
    local COL_W = math.floor(56 * szMul + 0.5)
    local ROW_H = math.floor(56 * szMul + 0.5)
    local GAP   = math.max(5, math.floor(8 * szMul + 0.5))
    -- Mobile cells are square, so half-width corners make them actual circles.
    local QR    = circleButtonsEnabled and math.floor(COL_W / 2) or math.max(9, math.floor(12 * szMul + 0.5))
    local Q_OFF        = Color3.fromRGB(3, 4, 7)
    local Q_ON         = SnowGetMobileActiveColor()
    local Q_BORDER     = Color3.fromRGB(26, 30, 38)
    local Q_BORDER_ON  = snowUiThemeName=="BIANCO" and Color3.fromRGB(255,255,255) or Color3.fromRGB(230,250,255)
    local Q_TEXT       = Color3.fromRGB(245, 245, 250)
    local Q_TEXT_ON    = Color3.fromRGB(5, 8, 12)

    local QW = COL_W * 3 + GAP * 2
    local QH = ROW_H * 4 + GAP * 3
    local mbGroup = Instance.new("Frame", mobGui)
    mbGroup.Name = "MobileButtons"
    mbGroup.Size = UDim2.new(0, QW + 12, 0, QH + 12)
    -- Default: right side, a bit higher on screen
    mbGroup.Position = UDim2.new(1, -(QW + 20), 0.32, 0)
    mbGroup.BackgroundTransparency = 1
    mbGroup.BorderSizePixel = 0
    mbGroup.Active = false -- only real buttons capture clicks
    mbGroup.ZIndex = 100
    do
        local sp = loadBtnPositions()["__group"]
        if type(sp) == "table" and sp.xo ~= nil then
            mbGroup.Position = UDim2.new(sp.xs or 0, sp.xo, sp.ys or 0, sp.yo or 0)
        end
    end

    -- Group drag: move whole pad when unlocked
    local _grpDn, _grpSp, _grpFp, _grpLi, _grpWd = false, nil, nil, nil, false
    local function beginGroupDrag(i)
        if mobileButtonsLocked then return end
        _grpDn = true; _grpWd = false; _grpSp = i.Position; _grpFp = mbGroup.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                if _grpWd then pcall(saveBtnPositions) end
                _grpDn = false; _grpWd = false
            end
        end)
    end
    UIS.InputChanged:Connect(function(i)
        if mobileButtonsLocked then _grpDn = false; return end
        if i == _grpLi and _grpDn and _grpSp and _grpFp then
            local dx = i.Position.X - _grpSp.X
            local dy = i.Position.Y - _grpSp.Y
            if math.abs(dx) > 8 or math.abs(dy) > 8 then
                _grpWd = true
                mbGroup.Position = UDim2.new(_grpFp.X.Scale, _grpFp.X.Offset + dx, _grpFp.Y.Scale, _grpFp.Y.Offset + dy)
            end
        end
    end)

    -- makeMobileBtn(label, col, row, isToggle, onAction, fullWidth)
    local function makeMobileBtn(label, col, rowN, isToggle, onAction, fullWidth)
        local w = fullWidth and QW or COL_W
        local relX = 8 + (fullWidth and 0 or (col * (COL_W + GAP)))
        local relY = 8 + rowN * (ROW_H + GAP)

        local frame = Instance.new("Frame", mbGroup)
        frame.Name = tostring(label):gsub("%s+","")
        frame.Size = UDim2.new(0, w, 0, ROW_H)
        frame.Position = UDim2.new(0, relX, 0, relY)
        frame.BackgroundColor3 = Q_OFF
        frame.BackgroundTransparency = 0.20
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 200
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = 1.5
        stroke.Transparency = 0.22

        local chrome=Instance.new("UIGradient",stroke)
        chrome.Enabled=false
        chrome.Rotation=45
        chrome.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(110,130,145)),ColorSequenceKeypoint.new(0.24,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.52,Color3.fromRGB(115,205,255)),ColorSequenceKeypoint.new(0.76,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(105,130,150))})

        local grad=Instance.new("UIGradient",frame)
        grad.Rotation=90
        grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(12,14,19)),ColorSequenceKeypoint.new(1,Color3.fromRGB(2,3,6))})

        -- subtle logo image on mobile buttons (loads async, mobile-safe)
        local bgIcon = Instance.new("ImageLabel", frame)
        bgIcon.Name = "BtnImage"
        bgIcon.Size = UDim2.new(1, 0, 1, 0)
        bgIcon.BackgroundTransparency = 1
        bgIcon.ImageTransparency = 0.72
        bgIcon.ScaleType = Enum.ScaleType.Crop
        bgIcon.ZIndex = 200
        bgIcon.Image = ""
        bgIcon.Visible = false
        Instance.new("UICorner", bgIcon).CornerRadius = UDim.new(0, QR)
        task.spawn(function()
            local asset = loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "dragon_menu_logo.png")
            if bgIcon and bgIcon.Parent and asset and asset ~= "" then
                bgIcon.Image = asset
            end
        end)

        local btn = Instance.new("TextButton", frame)
        btn.Name = "Label"
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = Q_TEXT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = math.max(8, math.floor((fullWidth and 11 or 10) * szMul + 0.5))
        btn.TextWrapped = true
        btn.LineHeight = 1.1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 201

        local isOn = false
        local _dn, _sp, _fp, _li, _wd = false, nil, nil, nil, false
        local btnScale = Instance.new("UIScale")
        btnScale.Scale = 1
        btnScale.Parent = frame

        local function pulseBtn(toScale)
            TweenService:Create(btnScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = toScale or 0.92}):Play()
            task.delay(0.1, function()
                TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)
        end

        local function paintMobileState(on,duration)
            chrome.Enabled=on
            local active=SnowGetMobileActiveColor()
            chrome.Color=snowUiThemeName=="BIANCO" and ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.5,Color3.fromRGB(220,220,220)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))}) or ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(110,130,145)),ColorSequenceKeypoint.new(0.24,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.52,Color3.fromRGB(115,205,255)),ColorSequenceKeypoint.new(0.76,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(105,130,150))})
            grad.Color=on and (snowUiThemeName=="BIANCO" and ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(220,220,220))}) or ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(170,230,255)),ColorSequenceKeypoint.new(0.48,active),ColorSequenceKeypoint.new(1,Color3.fromRGB(55,145,230))})) or ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(12,14,19)),ColorSequenceKeypoint.new(1,Color3.fromRGB(2,3,6))})
            TweenService:Create(frame,TweenInfo.new(duration or 0.22,Enum.EasingStyle.Quad),{BackgroundColor3=on and Q_ON or Q_OFF,BackgroundTransparency=on and 0.14 or 0.20}):Play()
            TweenService:Create(stroke,TweenInfo.new(duration or 0.22),{Color=on and Q_BORDER_ON or Q_BORDER,Transparency=on and 0 or 0.22,Thickness=on and 2.5 or 1.5}):Play()
            btn.TextColor3=on and Q_TEXT_ON or Q_TEXT
        end

        local function setter(s)
            isOn = s
            paintMobileState(s)
            pulseBtn(0.9)
        end

        -- Activated is reliable for Touch, mouse and gamepad; MouseButton1Click
        -- can fail after a short mobile touch when the button is also draggable.
        btn.Activated:Connect(function()
            if _wd then return end
            if isToggle then
                isOn = not isOn
                paintMobileState(isOn)
                pulseBtn(0.88)
                if onAction then onAction(isOn) end
            else
                pulseBtn(0.88)
                paintMobileState(true,0.1)
                task.delay(0.22, function()
                    paintMobileState(false,0.2)
                end)
                if onAction then onAction() end
            end
        end)

        frame.Name = (label:gsub("%s+","_"):gsub("\n","_"))

        -- Restore saved per-button position
        do
            local saved = loadBtnPositions()
            local sp = saved[frame.Name]
            if type(sp)=="table" and sp.xo ~= nil then
                frame.Position = UDim2.new(0, sp.xo, 0, sp.yo)
            end
        end

        -- Per-button drag (move this button only; blocked when mobile buttons are locked)
        btn.InputBegan:Connect(function(i)
            if mobileButtonsLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                _dn = true; _wd = false; _sp = i.Position; _fp = frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        if _wd then pcall(saveBtnPositions) end
                        _dn = false
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                _li = i
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == _li and _dn and _sp and _fp then
                if mobileButtonsLocked then return end
                local dx = i.Position.X - _sp.X
                local dy = i.Position.Y - _sp.Y
                if math.abs(dx) > 6 or math.abs(dy) > 6 then
                    _wd = true
                    frame.Position = UDim2.new(0, _fp.X.Offset + dx, 0, _fp.Y.Offset + dy)
                end
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if _wd then pcall(saveBtnPositions) end
                task.defer(function() _dn = false; _wd = false end)
            end
        end)

        mobileButtonFrames[frame.Name]={frame=frame,label=label}
        if mobileButtonVisibility[frame.Name]==false then frame.Visible=false end
        return frame, setter
    end

    local function syncLaggerVisuals()
        if mobBtnRefs.laggerCarry then
            mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive)
        end
        if mobBtnRefs.laggerNormal then
            mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive)
        end
        if mobBtnRefs.carrySpeed then
            mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled)
        end
    end

    -- Layout:
    -- TP BAT       | DROP BR      | AUTO LEFT
    -- INSTA RESET  | BAT AIMBOT   | AUTO RIGHT
    --             | TP DOWN      | CARRY SPEED
    --             | LAGGER CARRY | LAGGER NORMAL

    local _, refTPBat = makeMobileBtn("TP BAT", 0, 0, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
                return
            end
            if Dragon_forceAimbotOff then Dragon_forceAimbotOff() end
            Dragon.startTPBat()
            if Dragon.setTPBatVisual then Dragon.setTPBatVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            if autoBatSetVisual then autoBatSetVisual(false) end
        else
            Dragon.stopTPBat()
            if Dragon.setTPBatVisual then Dragon.setTPBatVisual(false) end
            -- leave aimbot alone so it can be turned on again
        end
    end, false)
    mobBtnRefs["tpBat"] = refTPBat

    local _, refInstaReset = makeMobileBtn("INSTA\nRESET", 0, 1, false, function()
        runInstaReset()
    end, false)
    mobBtnRefs["instaReset"] = refInstaReset

    local _, refDrop = makeMobileBtn("DROP BR", 1, 0, false, function() runDrop() end, false)
    mobBtnRefs["drop"] = refDrop

    local autoLeftFrame, refAutoLeft = makeMobileBtn("AUTO LEFT", 2, 0, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                return
            end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
        else
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoLeft"] = refAutoLeft

    local autoBatFrame, refAutoBat = makeMobileBtn("BAT\nAIMBOT", 1, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if aimbotMode=="BYPASS" then
                Dragon.startBatV2()
            else
                startBatAimbot()
            end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled or batV2Enabled) end
            if not autoBatEnabled and not batV2Enabled and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        else
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoBat"] = refAutoBat
    mobBtnRefs["autoBatLabel"] = autoBatFrame:FindFirstChild("Label")
    refreshMobileAimbotName=function()
        local label=mobBtnRefs and mobBtnRefs.autoBatLabel
        if label then
            label.Text=(aimbotMode=="BYPASS") and "BAT\nBYPASS" or "BAT\nAIMBOT"
        end
    end
    refreshMobileAimbotName()

    local autoRightFrame, refAutoRight = makeMobileBtn("AUTO RIGHT", 2, 1, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                if autoRightSetVisual then autoRightSetVisual(false) end
                return
            end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled = true; startAutoRight()
            if autoRightSetVisual then autoRightSetVisual(true) end
        else
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoRight"] = refAutoRight
    if autoPlayMode then
        autoLeftFrame.Visible=false; autoRightFrame.Visible=false
        local autoPlayFrame,refAutoPlay=makeMobileBtn("AUTO\nPLAY",2,0,true,function(on)
            Dragon.setAutoPlay(on)
        end,false)
        mobBtnRefs.autoPlay=refAutoPlay
        refAutoPlay(autoPlayEnabled)
    end

    local _, refTP = makeMobileBtn("TP DOWN", 1, 2, false, function() runTPFloor() end, false)
    mobBtnRefs["tpDown"] = refTP

    local _, refCarry = makeMobileBtn("CARRY SPEED", 2, 2, true, function(on)
        -- A manual selection must not be immediately overwritten by Auto Carry
        -- on the next 0.1-second check.
        autoSwitchSpeedEnabled=false
        Dragon.setExclusiveSpeed(on and "CARRY" or "NORMAL")
        saveConfig()
    end, false)
    mobBtnRefs["carrySpeed"] = refCarry

    local _, refLaggerCarry = makeMobileBtn("LAGGER CARRY", 1, 3, true, function(on)
        Dragon.setExclusiveSpeed(on and "LAGGER_CARRY" or "NORMAL")
        saveConfig()
    end, false)
    mobBtnRefs["laggerCarry"] = refLaggerCarry

    local _, refLaggerNormal = makeMobileBtn("LAGGER NORMAL", 2, 3, true, function(on)
        Dragon.setExclusiveSpeed(on and "LAGGER_NORMAL" or "NORMAL")
        saveConfig()
    end, false)
    mobBtnRefs["laggerNormal"] = refLaggerNormal
    mobBtnRefs["lagger"] = function(on)
        if on then
            if carrySpeedActive then
                if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(true) end
            else
                if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(true) end
            end
        else
            if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
            if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(false) end
        end
    end

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    syncLaggerVisuals()
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(Dragon.tpBat) end
end




-- ============================================================

-- ============================================================
-- FULL CONFIG LOAD
-- ============================================================
function Dragon.applyConfigData(d)
    if type(d)~="table" then return false end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if d.speedSystem=="V1" or d.speedSystem=="V2" then speedSystem=d.speedSystem end
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.dragonProfileAlternate)=="boolean" then dragonProfileAlternate=d.dragonProfileAlternate end
    if type(d.mobileButtonVisibility)=="table" then
        mobileButtonVisibility=d.mobileButtonVisibility
        for key,ref in pairs(mobileButtonFrames) do
            if ref and ref.frame then ref.frame.Visible=mobileButtonVisibility[key]~=false end
        end
    end
    if type(d.autoPlayMode)=="boolean" then autoPlayMode=d.autoPlayMode end
    if d.autoPlayRouteMode=="HALF" or d.autoPlayRouteMode=="FULL" then autoPlayRouteMode=d.autoPlayRouteMode end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.antiDieEnabled)=="boolean" then antiDieEnabled=d.antiDieEnabled end
    if d.dropBrainrotMode=="JUMP" or d.dropBrainrotMode=="STAND" then dropBrainrotMode=d.dropBrainrotMode end
    if type(d.autoAfterDropEnabled)=="boolean" then autoAfterDropEnabled=d.autoAfterDropEnabled end
    if d.autoAfterDropMode=="TP_BAT" then autoAfterDropMode="TP_BAT" else autoAfterDropMode="AIMBOT" end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    Dragon.antiRagdollVersion="V1"
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.antiKick)=="boolean" then Dragon.antiKick=d.antiKick end
    if type(d.tpBatAntiDie)=="boolean" then Dragon.tpBatAntiDie=d.tpBatAntiDie end
    if type(d.tpBatAntiVoid)=="boolean" then Dragon.tpBatAntiVoid=d.tpBatAntiVoid end
    if type(d.tpBatAutoDisableOnHit)=="boolean" then Dragon.tpBatAutoDisableOnHit=d.tpBatAutoDisableOnHit end
    if type(d.forceHit)=="boolean" then Dragon.forceHit=d.forceHit end
    if d.bodyLockMode=="PERM" or d.bodyLockMode=="RADIUS" then Dragon.bodyLockMode=d.bodyLockMode end
    if type(d.bodyLockRange)=="number" then Dragon.bodyLockRange=math.clamp(d.bodyLockRange,1,500) end
    if d.batCounterMode=="V2" then batCounterMode="V2" else batCounterMode="V1" end
    if type(d.bodyLock)=="boolean" and d.bodyLock then Dragon.setBodyLock(true) end
    if type(d.ragdollSteal)=="boolean" then Steal.RagdollSteal=d.ragdollSteal end
    if type(d.ragdollStealPauseSeconds)=="number" then Steal.RagdollStealPauseSeconds=math.clamp(d.ragdollStealPauseSeconds,.1,30) end
    if type(d.enemyRagdollTimerEnabled)=="boolean" then Dragon.enemyRagdollTimerEnabled=d.enemyRagdollTimerEnabled end
    if type(d.tpBatFreeCamera)=="boolean" then Dragon.tpBatFreeCamera=d.tpBatFreeCamera end
    if type(d.tpBatNoCamCollision)=="boolean" then Dragon.tpBatNoCamCollision=d.tpBatNoCamCollision end
    if type(d.noCamCollisionEnabled)=="boolean" then noCamCollisionEnabled=d.noCamCollisionEnabled end
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    if type(d.batV2Speed)=="number" then batV2Speed=d.batV2Speed end
    if type(d.batV2Enabled)=="boolean" then batV2Enabled=d.batV2Enabled end
    if d.aimbotMode=="AIMBOT" or d.aimbotMode=="BYPASS" then aimbotMode=d.aimbotMode end
    if type(d.aimbotNormalVersion)=="string" and d.aimbotNormalVersion:match("^V%d+$") then
        aimbotNormalVersion=d.aimbotNormalVersion
    else
        aimbotNormalVersion="V1"
    end
    if type(d.aimbotBypassVersion)=="string" and d.aimbotBypassVersion:match("^V%d+$") then
        aimbotBypassVersion=d.aimbotBypassVersion
    end
    if type(d.hitCircleEnabled)=="boolean" then SnowSetHitCircle(d.hitCircleEnabled) end
    if type(d.aimbotSpeed)=="number" then AIMBOT_SPEED=math.clamp(d.aimbotSpeed,1,200) end
    if type(d.laggerAimbotSpeed)=="number" then LAGGER_AIMBOT_SPEED=math.clamp(d.laggerAimbotSpeed,1,200) end
    if type(d.bypassAimbotSpeed)=="number" then BYPASS_AIMBOT_SPEED=math.clamp(d.bypassAimbotSpeed,1,200) end
    if type(d.bypassLaggerAimbotSpeed)=="number" then BYPASS_LAGGER_AIMBOT_SPEED=math.clamp(d.bypassLaggerAimbotSpeed,1,200) end
    if type(d.mirrorTPDownEnabled)=="boolean" then mirrorTPDownEnabled=d.mirrorTPDownEnabled end
    if type(d.snowThemeName)=="string" then snowThemeName=d.snowThemeName end
    if type(d.stealBarScale)=="number" then stealBarScale=math.clamp(d.stealBarScale,0.7,1.8) end
    if type(d.stealBarLocked)=="boolean" then stealBarLocked=d.stealBarLocked end
    if type(d.stealBarHidden)=="boolean" then stealBarHidden=d.stealBarHidden end
    if type(d.stealBarBackgroundUrl)=="string" then stealBarBackgroundUrl=d.stealBarBackgroundUrl end
    if type(d.stealBarPosition)=="table" then
        stealBarPosition={xs=tonumber(d.stealBarPosition.xs) or 0.5,xo=tonumber(d.stealBarPosition.xo) or 0,ys=tonumber(d.stealBarPosition.ys) or 0.88,yo=tonumber(d.stealBarPosition.yo) or 0}
    end
    if type(d.stealMode)=="number" then Steal.Mode=math.clamp(math.floor(d.stealMode),0,4) end
    if type(d.holdAtEnabled)=="boolean" then holdAtEnabled=d.holdAtEnabled end
    if type(d.stealRadii)=="table" then snowStealRadii.Normal=tonumber(d.stealRadii.Normal) or snowStealRadii.Normal end
    if type(d.grabRadius)=="number" then Steal.StealRadius=d.grabRadius end
    Steal.StealDuration=1.3 -- fixed, not user-configurable
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.aimbotAfterHit)=="boolean" then aimbotAfterHitEnabled=d.aimbotAfterHit end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if d.performanceProfile=="OPTIMIZE" or d.performanceProfile=="QUALITY" then
        DragonPerformanceProfile=d.performanceProfile
    end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.fpsBoostEnabled)=="boolean" then fpsBoostEnabled=d.fpsBoostEnabled end
    if type(d.fpsCapValue)=="number" then fpsCapValue=math.clamp(math.floor(d.fpsCapValue),60,1000) end
    if type(d.fpsCapEnabled)=="boolean" then fpsCapEnabled=d.fpsCapEnabled end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if d.stretchRezScale==2 or d.stretchRezScale==3 or d.stretchRezScale==4 then stretchRezScale=d.stretchRezScale end
    if type(d.autoTPEnabled)=="boolean" then autoTPEnabled=d.autoTPEnabled end
    if type(d.autoTPHeight)=="number" then autoTPHeight=d.autoTPHeight end
    if d.tpDownMethod=="NORMAL" or d.tpDownMethod=="SLOW" or d.tpDownMethod=="ZIGZAG" then tpDownMethod=d.tpDownMethod end
    if type(d.uiAutoFadeEnabled)=="boolean" then uiAutoFadeEnabled=d.uiAutoFadeEnabled end
    if d.tabsPosition=="TOP" or d.tabsPosition=="BOTTOM" then tabsPosition=d.tabsPosition end
    if d.collapsedTabMode=="LEFT" or d.collapsedTabMode=="RIGHT" or d.collapsedTabMode=="FREE" then collapsedTabMode=d.collapsedTabMode end
    if type(d.colorfulGraphicsEnabled)=="boolean" then colorfulGraphicsEnabled=d.colorfulGraphicsEnabled end
    if type(d.motionBlurEnabled)=="boolean" then motionBlurEnabled=d.motionBlurEnabled end
    if type(d.fovValue)=="number" then fovValue=(d.fovValue==120 and 180 or d.fovValue) end
    if type(d.fovIndex)=="number" then fovIndex=d.fovIndex end
    if fovValue~=80 and fovValue~=180 then fovValue=80 end
    for i,value in ipairs(fovOptions) do if value==fovValue then fovIndex=i; break end end
    if type(d.skyTheme)=="string" then SnowCurrentSkyTheme=d.skyTheme end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.logoCircleEnabled)=="boolean" then logoCircleEnabled=d.logoCircleEnabled end
    if type(d.uiLocked)=="boolean" then uiLocked=d.uiLocked end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.mobileButtonsLocked)=="boolean" then mobileButtonsLocked=d.mobileButtonsLocked end
    if type(d.guiPosition)=="table" then
        snowGuiPosition={xs=tonumber(d.guiPosition.xs) or 0,xo=tonumber(d.guiPosition.xo) or 6,ys=tonumber(d.guiPosition.ys) or 0,yo=tonumber(d.guiPosition.yo) or 48}
    end
    if type(d.guiScale)=="number" then snowGuiScale=math.clamp(d.guiScale,0.50,1.30) end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.headlessEnabled)=="boolean" then headlessEnabled=d.headlessEnabled end
    if type(d.korbloxMode)=="string" and (d.korbloxMode=="OFF" or d.korbloxMode=="LEFT" or d.korbloxMode=="RIGHT" or d.korbloxMode=="BOTH") then
        korbloxMode=d.korbloxMode; korbloxEnabled=(korbloxMode~="OFF")
    elseif type(d.korbloxEnabled)=="boolean" then
        korbloxEnabled=d.korbloxEnabled; korbloxMode=korbloxEnabled and "RIGHT" or "OFF"
    end
    if type(d.korbloxLastMode)=="string" and (d.korbloxLastMode=="LEFT" or d.korbloxLastMode=="RIGHT" or d.korbloxLastMode=="BOTH") then korbloxLastMode=d.korbloxLastMode end
    if d.batSkinMode=="NONE" or d.batSkinMode=="SCYTHE" or d.batSkinMode=="SWORD" then
        batSkinMode=d.batSkinMode
    end
    if type(d.batSoundsEnabled)=="boolean" then batSoundsEnabled=d.batSoundsEnabled end
    if d.medusaSkinMode=="NONE" or d.medusaSkinMode=="SKULL" or d.medusaSkinMode=="GOLDEN_DESERT_EAGLE" then medusaSkinMode=d.medusaSkinMode end
    if type(d.medusaSoundsEnabled)=="boolean" then medusaSoundsEnabled=d.medusaSoundsEnabled end
    if type(d.swordColorMode)=="string" and (swordColors[d.swordColorMode]~=nil or d.swordColorMode=="DEFAULT") then
        swordColorMode=d.swordColorMode
    end
    if type(d.espEnabled)=="boolean" then espEnabled=d.espEnabled end
    if type(d.enemySpeedEnabled)=="boolean" then enemySpeedEnabled=d.enemySpeedEnabled end
    if type(d.espBoxEnabled)=="boolean" then espBoxEnabled=d.espBoxEnabled end
    if type(d.espLineEnabled)=="boolean" then espLineEnabled=d.espLineEnabled end
    if type(d.backgroundEnabled)=="boolean" then backgroundEnabled=d.backgroundEnabled end
    if type(d.backgroundIndex)=="number" then backgroundIndex=math.clamp(math.floor(d.backgroundIndex),-1,#BG_IMAGE_URLS) end
    if type(d.customGuiBackgroundUrl)=="string" then customGuiBackgroundUrl=d.customGuiBackgroundUrl end
    if type(d.snowThemeBackgroundIndex)=="table" then
        if type(d.snowThemeBackgroundIndex.AZZURRO)=="number" then SnowThemeBackgroundIndex.AZZURRO=math.max(1,math.floor(d.snowThemeBackgroundIndex.AZZURRO)) end
        if type(d.snowThemeBackgroundIndex.BIANCO)=="number" then SnowThemeBackgroundIndex.BIANCO=math.max(1,math.floor(d.snowThemeBackgroundIndex.BIANCO)) end
    else
        SnowThemeBackgroundIndex.AZZURRO=math.max(1,backgroundIndex)
    end
    -- Do not restore a wallpaper from an older collection.
    snowLastBackgroundUrl=nil
    snowUiThemeName="BIANCO"
    if type(d.e01Alert)=="boolean" then e01AlertEnabled=d.e01Alert end
    if type(d.e01AlertScale)=="number" then e01AlertScale=math.clamp(d.e01AlertScale,.7,1.4) end
    if type(d.hidePingWarner)=="boolean" then hidePingWarner=d.hidePingWarner end
    if type(d.stealBarLocked)=="boolean" then stealBarLocked=d.stealBarLocked end
    if type(d.stealBarHidden)=="boolean" then stealBarHidden=d.stealBarHidden end
    if type(d.titleIndex)=="number" then titleIndex=math.clamp(math.floor(d.titleIndex),1,#TITLE_IMAGE_ASSETS) end
    if type(d.introSkipEnabled)=="boolean" then introSkipEnabled=d.introSkipEnabled end
    introVersion=1
    if type(d.introSongIndex)=="number" then introSongIndex=math.clamp(math.floor(d.introSongIndex),1,#Dragon_INTRO_SONGS) end
    if type(d.introBackgroundIndex)=="number" then introBackgroundIndex=math.clamp(math.floor(d.introBackgroundIndex),1,#Dragon_INTRO_BACKGROUNDS) end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if d.autoCarryMode=="ON_PICKUP" or d.autoCarryMode=="WHEN_NEAR" then autoCarryMode=d.autoCarryMode end
    if type(d.autoCarryStealRange)=="number" then autoCarryStealRange=math.clamp(d.autoCarryStealRange,1,200) end
    if type(d.animPackName)=="string" then animPackName=d.animPackName end
    animPackEnabled=(animPackName~="OFF")
    if type(d.autoBat)=="boolean" then autoBatEnabled=d.autoBat end

    -- restore keybinds (KB dual PC/Gamepad)
    local function _loadKC(name)
        if type(name)~="string" or name=="" then return nil end
        local ok,kc=pcall(function() return Enum.KeyCode[name] end)
        if ok and kc and kc~=Enum.KeyCode.Unknown then return kc end
        return nil
    end
    local function _applyKBEntry(entry, data)
        if type(entry)~="table" or type(data)~="table" then return end
        if data.kb ~= nil then entry.kb = _loadKC(data.kb) end
        if data.gp ~= nil then entry.gp = _loadKC(data.gp) end
    end
    -- new format: d.keybinds = { AutoBat = {kb="E", gp="ButtonY"}, ... }
    if type(d.keybinds)=="table" then
        for name,data in pairs(d.keybinds) do
            if KB[name] then _applyKBEntry(KB[name], data) end
        end
    end
    -- legacy format: d.autoBatKey = {kb="E", gp=...}
    local legacyMap = {
        dropBrainrotKey="DropBrainrot", autoLeftKey="AutoLeft", autoRightKey="AutoRight",
        autoBatKey="AutoBat", laggerToggleKey="LaggerToggle", laggerCarryKey="LaggerCarry",
        tpBatKey="TPBat", tpFloorKey="TPFloor", guiHideKey="GuiHide",
        speedToggleKey="SpeedToggle", batV2Key="BatV2",
    }
    for cfgKey, kbName in pairs(legacyMap) do
        if type(d[cfgKey])=="table" and KB[kbName] then
            _applyKBEntry(KB[kbName], d[cfgKey])
        end
    end
    return true
end

pcall(function()
    if not(isfile and isfile(Dragon_CONFIG_FILE)) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile(Dragon_CONFIG_FILE)) end)
    if ok then Dragon.applyConfigData(d) end
end)
-- Prefer the last explicit size checkpoint.  This is written immediately on
-- touch devices, while the main config is written on its normal cadence.
loadStealBarScale()

-- The saved setting is loaded after the initial setup above, so apply it once
-- more now to restore both connections and humanoid states correctly.
if Dragon.setGlobalAntiDie then Dragon.setGlobalAntiDie(antiDieEnabled) end

-- ============================================================
-- APPLY CONFIG
-- ============================================================
pcall(function()
    if DragonApplyFpsCap then DragonApplyFpsCap() end
    if fpsBoostEnabled then
        task.spawn(function() task.wait(1); if enableFPSBoost then enableFPSBoost() end end)
    end
    if antiLagEnabled then
        task.spawn(function() task.wait(1); if enableAntiLag then enableAntiLag() end end)
    end
    if animPackName and animPackName~="OFF" then
        task.spawn(function() task.wait(1.2); pcall(function() applyAnimPack(animPackName) end) end)
    end
    if stretchRezEnabled then task.spawn(function() task.wait(0.5); if enableStretchRez then enableStretchRez() end end) end
    applySnowAmbitiousVisualEffects()
    if antiRagdollEnabled then task.spawn(function() task.wait(0.5); if startAntiRagdoll then startAntiRagdoll() end end) end
    if infJumpEnabled then task.spawn(function() task.wait(0.5); if setInfJumpInternal then setInfJumpInternal(true) end end) end
    if Steal.AutoStealEnabled then task.spawn(function() task.wait(1); if startAutoSteal then startAutoSteal() end end) end
    if batCounterEnabled then task.spawn(function() task.wait(1); if startBatCounter then startBatCounter() end end) end
    if Dragon.antiKick then task.spawn(function() task.wait(1); Dragon.enableAntiKick(); if Dragon.setAntiKickVisual then Dragon.setAntiKickVisual(true) end end) end
    if medusaCounterEnabled then task.spawn(function() task.wait(1); local char=LP.Character; if char and setupMedusa then setupMedusa(char) end end) end
    if autoTPEnabled then task.spawn(function() task.wait(0.5); if startAutoTP then startAutoTP() end end) end
    if SnowCurrentSkyTheme and SnowCurrentSkyTheme~="" then task.spawn(function() task.wait(1); if SnowApplySkyTheme then SnowApplySkyTheme(SnowCurrentSkyTheme) end end) end
    if espEnabled then task.spawn(function() task.wait(1); startESP() end) end
end)

-- ============================================================
-- CYBER GUI
-- ============================================================
;(function()
PlayerGui=LP:WaitForChild("PlayerGui")
function makeDraggable_cyber(dragTarget,moveTarget,verticalOnly)
    moveTarget=moveTarget or dragTarget
    local dragging,dragInput,dragStart,startPos=false
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=moveTarget.Position; moveTarget:SetAttribute("CyberDragMoved",false)
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            if uiLocked then return end
            local delta=input.Position-dragStart
            if delta.Magnitude>4 then moveTarget:SetAttribute("CyberDragMoved",true) end
            local lockX=(type(verticalOnly)=="function" and verticalOnly()) or verticalOnly
            local xOffset=lockX and startPos.X.Offset or (startPos.X.Offset+delta.X)
            moveTarget.Position=UDim2.new(startPos.X.Scale,xOffset,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end
C={
    bg=Color3.fromRGB(6,6,6),bgDark=Color3.fromRGB(3,3,3),row=Color3.fromRGB(16,16,16),
    input=Color3.fromRGB(16,16,16),blue=Color3.fromRGB(145,220,255),blueDim=Color3.fromRGB(82,170,205),
    blueDark=Color3.fromRGB(12,45,62),text=Color3.fromRGB(255,255,255),textDim=Color3.fromRGB(180,225,240),
    textMuted=Color3.fromRGB(120,180,205),white=Color3.fromRGB(145,220,255),divider=Color3.fromRGB(48,120,150),
    green=Color3.fromRGB(80,220,120),
}
function guiCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c end
function guiStroke(p,col,t) local s=Instance.new("UIStroke"); s.Color=col or Color3.fromRGB(60,60,70); s.Thickness=t or 1; s.Parent=p; return s end
function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end
GuiToggleSetters={}
GuiRefs={}
LeftPanel=nil
Keys={
    circle=Enum.KeyCode.E,speed=Enum.KeyCode.Q,carryMode=Enum.KeyCode.C,
    laggerToggle=Enum.KeyCode.K,laggerCarry=nil,guiHide=Enum.KeyCode.RightControl,
    dropBrainrot=Enum.KeyCode.H,tpDown=Enum.KeyCode.T,
    autoLeft=Enum.KeyCode.J,autoRight=Enum.KeyCode.L,
    tpBat=Enum.KeyCode.Y,
}
pcall(function()
    if not(isfile and isfile(Dragon_CONFIG_FILE)) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile(Dragon_CONFIG_FILE)) end)
    if not (ok and type(d)=="table") then return end
    if type(d.keys)=="table" then
        for k,v in pairs(d.keys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys[k]=kc end
        end
    end
    -- also hydrate KB if already defined
    if KB then
        local function _loadKC(name)
            if type(name)~="string" or name=="" then return nil end
            local ok2,kc=pcall(function() return Enum.KeyCode[name] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then return kc end
            return nil
        end
        if type(d.keybinds)=="table" then
            for name,data in pairs(d.keybinds) do
                if KB[name] and type(data)=="table" then
                    if data.kb ~= nil then KB[name].kb = _loadKC(data.kb) end
                    if data.gp ~= nil then KB[name].gp = _loadKC(data.gp) end
                end
            end
        end
        local legacyMap = {
            dropBrainrotKey="DropBrainrot", autoLeftKey="AutoLeft", autoRightKey="AutoRight",
            autoBatKey="AutoBat", laggerToggleKey="LaggerToggle", laggerCarryKey="LaggerCarry",
            tpBatKey="TPBat", tpFloorKey="TPFloor", guiHideKey="GuiHide",
            speedToggleKey="SpeedToggle", batV2Key="BatV2",
        }
        for cfgKey, kbName in pairs(legacyMap) do
            local data=d[cfgKey]
            if type(data)=="table" and KB[kbName] then
                if data.kb ~= nil then KB[kbName].kb = _loadKC(data.kb) end
                if data.gp ~= nil then KB[kbName].gp = _loadKC(data.gp) end
            end
        end
    end
end)
_GuiKeys=Keys
-- mirror KB → Keys after both exist
pcall(function()
    if KB.GuiHide and KB.GuiHide.kb then Keys.guiHide = KB.GuiHide.kb end
    if KB.SpeedToggle and KB.SpeedToggle.kb then Keys.carryMode = KB.SpeedToggle.kb end
    if KB.LaggerToggle and KB.LaggerToggle.kb then Keys.laggerToggle = KB.LaggerToggle.kb end
    if KB.LaggerCarry and KB.LaggerCarry.kb then Keys.laggerCarry = KB.LaggerCarry.kb end
    if KB.AutoBat and KB.AutoBat.kb then Keys.circle = KB.AutoBat.kb end
    if KB.TPBat and KB.TPBat.kb then Keys.tpBat = KB.TPBat.kb end
    if KB.AutoLeft and KB.AutoLeft.kb then Keys.autoLeft = KB.AutoLeft.kb end
    if KB.AutoRight and KB.AutoRight.kb then Keys.autoRight = KB.AutoRight.kb end
    if KB.DropBrainrot and KB.DropBrainrot.kb then Keys.dropBrainrot = KB.DropBrainrot.kb end
    if KB.TPFloor and KB.TPFloor.kb then Keys.tpDown = KB.TPFloor.kb end
    _GuiKeys = Keys
end)

-- BUILD HUB GUI
;(function()
    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="Dragon"; GuiHub.ResetOnSpawn=false
    GuiHub.IgnoreGuiInset=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; GuiHub.DisplayOrder=999999; GuiHub.Enabled=Dragon_INTRO_DONE
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(GuiHub) end
    end)
    if not pcall(function() GuiHub.Parent=game:GetService("CoreGui") end) then
        GuiHub.Parent=PlayerGui
    end
    DragonProtectGui(GuiHub)
    dragonAfterIntro(function() if GuiHub and GuiHub.Parent then GuiHub.Enabled=true end end)
    GuiRefs.hub=GuiHub
    local Outer=Instance.new("Frame")
    -- Wider, studio-style panel: matches the reference's rounded portrait card
    -- while keeping the existing pages and touch controls intact.
    Outer.Name="Outer"; Outer.Size=UDim2.new(0,375,0,540)
    Outer.Position=snowGuiPosition and UDim2.new(snowGuiPosition.xs,snowGuiPosition.xo,snowGuiPosition.ys,snowGuiPosition.yo) or UDim2.new(0,6,0,48)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=false; Outer.Parent=GuiHub
    GuiRefs.outer=Outer
    local OuterScale=Instance.new("UIScale"); OuterScale.Scale=snowGuiScale or 0.70; OuterScale.Parent=Outer; GuiRefs.outerScale=OuterScale
    -- Opening/closing uses a short scale animation.  Keep those transient
    -- values out of the persisted preference, otherwise an interrupted tween
    -- can make the next launch permanently smaller.
    local uiScaleAnimating=false
    Outer:GetPropertyChangedSignal("Position"):Connect(function()
        snowGuiPosition={xs=Outer.Position.X.Scale,xo=Outer.Position.X.Offset,ys=Outer.Position.Y.Scale,yo=Outer.Position.Y.Offset}
        if saveConfig then saveConfig() end
    end)
    OuterScale:GetPropertyChangedSignal("Scale"):Connect(function()
        if uiScaleAnimating then return end
        snowGuiScale=math.clamp(OuterScale.Scale,0.50,1.30)
        if saveConfig then saveConfig() end
    end)
    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=false; Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=0; Inner.BorderSizePixel=0; Inner.Parent=Outer
    -- The main shell is intentionally borderless: the rounded panel itself
    -- defines the edge, without the old dark outline around the GUI.
    guiCorner(Inner,16); GuiRefs.inner=Inner
    local BgCont=Instance.new("Frame")
    -- Keep the artwork inside the panel's existing border rather than covering it.
    BgCont.Name="BackgroundContainer"; BgCont.Size=UDim2.new(1,-2,1,-2); BgCont.Position=UDim2.new(0,1,0,1); BgCont.BackgroundTransparency=1; BgCont.ZIndex=0; BgCont.ClipsDescendants=true; BgCont.Parent=Inner; guiCorner(BgCont,15)
    local BgGrad=Instance.new("Frame")
    BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0); BgGrad.BackgroundColor3=C.bgDark
    BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BgCont; guiCorner(BgGrad,15)
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(4,4,4)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(7,7,7)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,4,4))})
    grad.Rotation=135; grad.Parent=BgGrad; GuiRefs.bgGrad=BgGrad
    local BgImg=Instance.new("ImageLabel")
    BgImg.Name="BackgroundImage"; BgImg.Size=UDim2.new(1,0,1,0); BgImg.BackgroundTransparency=1
    BgImg.Image=""; BgImg.ScaleType=Enum.ScaleType.Crop; BgImg.ZIndex=0; BgImg.ImageTransparency=0.12; BgImg.Visible=false
    BgImg.Parent=BgCont; guiCorner(BgImg,15); GuiRefs.backgroundImage=BgImg; bgImageRef=BgImg
    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,-28,0,68); HF.Position=UDim2.new(0,14,0,8); HF.ClipsDescendants=false; HF.BackgroundColor3=Color3.fromRGB(0,0,0); HF.BackgroundTransparency=.34; HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2; guiCorner(HF,14)
    makeDraggable_cyber(HF,Outer)
    -- Circle logo ImageButton next to script name
    local LogoBtn=Instance.new("ImageButton")
    LogoBtn.Name="LogoCircle"
    LogoBtn.Size=UDim2.new(0,40,0,40)
    LogoBtn.Position=UDim2.new(0,10,0,40)
    LogoBtn.BackgroundColor3=Color3.fromRGB(20,20,24)
    LogoBtn.BackgroundTransparency=0
    LogoBtn.BorderSizePixel=0
    LogoBtn.AutoButtonColor=false
    LogoBtn.ScaleType=Enum.ScaleType.Crop
    LogoBtn.Image=""
    LogoBtn.ZIndex=3
    LogoBtn.Visible = false
    LogoBtn.Parent=HF
    Instance.new("UICorner",LogoBtn).CornerRadius=UDim.new(1,0)
    local logoStroke=Instance.new("UIStroke",LogoBtn)
    logoStroke.Color=Color3.fromRGB(80,80,90)
    logoStroke.Thickness=1.5
    logoCircleRef = LogoBtn
    GuiRefs.logoCircle = LogoBtn
    logoCircleEnabled = false
    LogoBtn.Visible = false
    task.spawn(function()
        local LOGO_URL="https://files.catbox.moe/mlyr71.png"
        local asset = loadCustomImageAsset(LOGO_URL, "dragon_menu_logo.png")
        if LogoBtn and LogoBtn.Parent then
            LogoBtn.Image = asset
        end
    end)
    LogoBtn.MouseButton1Click:Connect(function()
        -- soft pulse feedback
        pcall(function()
            local s = LogoBtn.Size
            TweenService:Create(LogoBtn, TweenInfo.new(0.08), {Size = UDim2.new(0,34,0,34)}):Play()
            task.delay(0.08, function()
                TweenService:Create(LogoBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Size = UDim2.new(0,40,0,40)}):Play()
            end)
        end)
    end)
    -- Fixed wordmark instead of the old title artwork.
    local TL=Instance.new("TextLabel")
    TL.Name="SnowTitle"
    TL.AnchorPoint=Vector2.new(0,0)
    TL.Position=UDim2.new(0,96,0,18)
    TL.Size=UDim2.new(0,202,0,34)
    TL.BackgroundTransparency=1
    TL.BorderSizePixel=0
    TL.Text="DRAGON HUB"
    TL.TextColor3=Color3.fromRGB(255,255,255)
    TL.TextSize=24
    TL.Font=Enum.Font.GothamBlack
    TL.TextXAlignment=Enum.TextXAlignment.Left
    TL.ZIndex=6
    TL.Parent=HF
    GuiRefs.snowTitle=TL
    local titleSub=Instance.new("TextLabel")
    titleSub.Name="DragonDuelsSubtitle"; titleSub.Position=UDim2.new(0,84,0,39); titleSub.Size=UDim2.new(0,210,0,18)
    titleSub.BackgroundTransparency=1; titleSub.Text="discord.gg/dragonhub"; titleSub.TextColor3=C.textDim
    titleSub.TextSize=11; titleSub.Font=Enum.Font.GothamBold; titleSub.TextXAlignment=Enum.TextXAlignment.Left; titleSub.ZIndex=6; titleSub.Parent=HF
    -- Fixed Dragon Duels artwork in the original top-left slot.
    local headerPhoto=Instance.new("ImageButton")
    headerPhoto.Name="DragonDuelsHeaderImage"; headerPhoto.Size=UDim2.new(0,54,0,54); headerPhoto.Position=UDim2.new(0,18,0,10)
    headerPhoto.BackgroundTransparency=1; headerPhoto.BorderSizePixel=0; headerPhoto.AutoButtonColor=false; headerPhoto.Image="rbxassetid://91781095721218"
    headerPhoto.ScaleType=Enum.ScaleType.Crop; headerPhoto.ImageColor3=Color3.fromRGB(255,255,255); headerPhoto.ZIndex=6; headerPhoto.Parent=HF
    guiCorner(headerPhoto,7); local headerPhotoStroke=Instance.new("UIStroke",headerPhoto); headerPhotoStroke.Color=Color3.fromRGB(255,255,255); headerPhotoStroke.Thickness=1; headerPhotoStroke.Transparency=0
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,40,0,30); CloseBtn.Position=UDim2.new(1,-50,0,19)
    CloseBtn.BackgroundTransparency=1; CloseBtn.BorderSizePixel=0
    CloseBtn.Name="ThemeCloseButton"; CloseBtn.Text="−"; CloseBtn.TextColor3=Color3.fromRGB(255,255,255); CloseBtn.TextTransparency=0; CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=20
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    GuiRefs.closeButton=CloseBtn
    guiCorner(CloseBtn,10); local closeStroke=guiStroke(CloseBtn,Color3.fromRGB(105,105,112),1); closeStroke.Transparency=1
    CloseBtn.MouseEnter:Connect(function() end)
    CloseBtn.MouseLeave:Connect(function() end)
    local lockButton=Instance.new("TextButton")
    lockButton.Name="DragonUiLockButton"; lockButton.Size=UDim2.new(0,34,0,30); lockButton.Position=UDim2.new(1,-86,0,19)
    lockButton.BackgroundTransparency=1; lockButton.BorderSizePixel=0; lockButton.Font=Enum.Font.GothamBold; lockButton.TextSize=17; lockButton.ZIndex=6; lockButton.Parent=HF
    local function setHeaderUiLock(locked)
        uiLocked=locked==true
        lockButton.Text=uiLocked and "🔒" or "🔓"
        lockButton.TextColor3=uiLocked and Color3.fromRGB(255,255,255) or Color3.fromRGB(185,185,192)
    end
    GuiRefs.setUiLocked=setHeaderUiLock
    setHeaderUiLock(uiLocked)
    lockButton.MouseButton1Click:Connect(function()
        setHeaderUiLock(not uiLocked)
        saveConfig()
    end)
    -- Compact reopen pill shown after the main UI is closed.
    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Name="SnowOpenPill"
    -- Keep the original card size, but dock it beyond the right edge so only
    -- its avatar end is visible as the reopen tab.
    MiniBtn.Size=UDim2.new(0,195,0,64)
    MiniBtn.Position=UDim2.new(1,-56,.5,-32)
    MiniBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
    MiniBtn.BackgroundTransparency=.25
    MiniBtn.BorderSizePixel=0
    MiniBtn.Text=""
    MiniBtn.AutoButtonColor=false
    MiniBtn.ZIndex=20
    MiniBtn.Visible=false
    MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn, 19)
    local miniStroke=Instance.new("UIStroke", MiniBtn)
    miniStroke.Color=Color3.fromRGB(82,100,112)
    miniStroke.Thickness=1
    miniStroke.Transparency=1
    local miniAvatarPlate=Instance.new("Frame",MiniBtn)
    miniAvatarPlate.Size=UDim2.new(0,48,0,48); miniAvatarPlate.Position=UDim2.new(0,8,.5,-24); miniAvatarPlate.BackgroundTransparency=1; miniAvatarPlate.BorderSizePixel=0; miniAvatarPlate.ZIndex=21
    local miniAvatar=Instance.new("ImageLabel",miniAvatarPlate)
    miniAvatar.Name="DragonProfileImage"; miniAvatar.Size=UDim2.new(1,-4,1,-4); miniAvatar.Position=UDim2.new(0,2,0,2); miniAvatar.BackgroundTransparency=1; miniAvatar.Image=DragonCurrentProfileAsset(); miniAvatar.ScaleType=Enum.ScaleType.Crop; miniAvatar.ZIndex=22; guiCorner(miniAvatar,5)
    local miniImage=Instance.new("TextLabel", MiniBtn)
    miniImage.Name="ReopenTitle"; miniImage.Size=UDim2.new(0,0,0,0); miniImage.Position=UDim2.new(0,0,0,0)
    miniImage.BackgroundTransparency=1; miniImage.Text=""; miniImage.TextColor3=Color3.fromRGB(255,255,255); miniImage.Visible=false
    miniImage.TextSize=13; miniImage.Font=Enum.Font.GothamBlack; miniImage.TextXAlignment=Enum.TextXAlignment.Left; miniImage.ZIndex=22
    GuiRefs.reopenTitle=miniImage
    local miniSub=Instance.new("TextLabel",MiniBtn)
    miniSub.Size=UDim2.new(0,0,0,0); miniSub.Position=UDim2.new(0,0,0,0); miniSub.BackgroundTransparency=1; miniSub.Text=""; miniSub.Visible=false; miniSub.ZIndex=22

    local function applyCollapsedTabMode(mode,keepVertical)
        if mode~="LEFT" and mode~="RIGHT" and mode~="FREE" then mode="RIGHT" end
        collapsedTabMode=mode
        MiniBtn.Size=UDim2.new(0,195,0,64)
        local ys,yo=MiniBtn.Position.Y.Scale,MiniBtn.Position.Y.Offset
        if not keepVertical then ys,yo=.5,-32 end
        if mode=="LEFT" then
            -- The card stays off-screen on the left; its right-side portrait is visible.
            MiniBtn.Position=UDim2.new(0,-139,ys,yo)
            miniAvatarPlate.Position=UDim2.new(1,-56,.5,-24)
            miniImage.Visible=false; miniSub.Visible=false
        elseif mode=="RIGHT" then
            -- The card stays off-screen on the right; its left-side portrait is visible.
            MiniBtn.Position=UDim2.new(1,-56,ys,yo)
            miniAvatarPlate.Position=UDim2.new(0,8,.5,-24)
            miniImage.Visible=false; miniSub.Visible=false
        else
            if not keepVertical then MiniBtn.Position=UDim2.new(.5,-98,ys,yo) end
            miniAvatarPlate.Position=UDim2.new(0,8,.5,-24)
            miniImage.Size=UDim2.new(1,-76,0,23); miniImage.Position=UDim2.new(0,68,0,13); miniImage.Text="DRAGON HUB"; miniImage.Visible=true
            miniSub.Size=UDim2.new(1,-76,0,14); miniSub.Position=UDim2.new(0,68,0,35); miniSub.Text="discord.gg/dragonhub"; miniSub.TextColor3=Color3.fromRGB(235,235,235); miniSub.TextTransparency=.08; miniSub.TextSize=8; miniSub.Font=Enum.Font.GothamBold; miniSub.TextXAlignment=Enum.TextXAlignment.Left; miniSub.Visible=true
        end
    end
    GuiRefs.applyCollapsedTabMode=applyCollapsedTabMode
    applyCollapsedTabMode(collapsedTabMode,false)
    -- This drag belongs only to the collapsed tab.  FREE can move everywhere;
    -- the two docked modes retain their vertical-only movement.
    local miniDragging,miniDragInput,miniDragStart,miniStartPosition=false,nil,nil,nil
    MiniBtn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            miniDragging=true; miniDragStart=input.Position; miniStartPosition=MiniBtn.Position; MiniBtn:SetAttribute("CyberDragMoved",false)
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then miniDragging=false end end)
        end
    end)
    MiniBtn.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then miniDragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==miniDragInput and miniDragging and not uiLocked then
            local delta=input.Position-miniDragStart
            if delta.Magnitude>4 then MiniBtn:SetAttribute("CyberDragMoved",true) end
            local docked=collapsedTabMode~="FREE"
            MiniBtn.Position=UDim2.new(miniStartPosition.X.Scale,docked and miniStartPosition.X.Offset or miniStartPosition.X.Offset+delta.X,miniStartPosition.Y.Scale,miniStartPosition.Y.Offset+delta.Y)
        end
    end)
    MiniBtn.MouseEnter:Connect(function()
        tw(MiniBtn, {BackgroundTransparency=.1})
    end)
    MiniBtn.MouseLeave:Connect(function()
        tw(MiniBtn, {BackgroundTransparency=.25})
    end)
    local guiAnimBusy = false
    local function getBaseScale()
        return math.clamp(tonumber(snowGuiScale) or 0.70,0.50,1.30)
    end
    local function showGui()
        if guiAnimBusy then return end
        guiAnimBusy = true
        uiScaleAnimating = true
        MiniBtn.Visible = false
        Outer.Visible = true
        local base = getBaseScale()
        if OuterScale then OuterScale.Scale=base end
        if Inner then
            Inner.BackgroundTransparency = 0.35
        end
        local ti = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        if Inner then
            TweenService:Create(Inner, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end
        task.delay(0.3, function()
            if OuterScale then OuterScale.Scale=base end
            uiScaleAnimating=false
            guiAnimBusy=false
        end)
    end
    local function hideGui()
        if guiAnimBusy then return end
        guiAnimBusy = true
        uiScaleAnimating = true
        local base = getBaseScale()
        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        if OuterScale then OuterScale.Scale=base end
        if Inner then
            TweenService:Create(Inner, ti, {BackgroundTransparency = 0.45}):Play()
        end
        task.delay(0.2, function()
            Outer.Visible = false
            applyCollapsedTabMode(collapsedTabMode,true)
            MiniBtn.Visible = true
            if OuterScale then OuterScale.Scale = base end
            uiScaleAnimating = false
            if Inner then Inner.BackgroundTransparency = 0 end
            -- mini button pop-in
            local ms = Instance.new("UIScale")
            ms.Scale = 0.7
            ms.Parent = MiniBtn
            TweenService:Create(ms, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            task.delay(0.25, function() pcall(function() ms:Destroy() end) end)
            guiAnimBusy = false
        end)
    end
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(function()
        if MiniBtn:GetAttribute("CyberDragMoved") then return end
        showGui()
    end)
    -- expose for keybind
    GuiRefs.showGui = showGui
    GuiRefs.hideGui = hideGui
    local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,14,0,82); HSep.Size=UDim2.new(1,-28,0,1); HSep.BackgroundColor3=Color3.fromRGB(105,105,114)
    HSep.BackgroundTransparency=0.18; HSep.BorderSizePixel=0; HSep.Parent=Inner; HSep.ZIndex=2; HSep.Visible=true; GuiRefs.tabSeparator=HSep
    LeftPanel=Instance.new("Frame")
    LeftPanel.Name="TabBar"; LeftPanel.Size=UDim2.new(1,-4,0,38); LeftPanel.Position=UDim2.new(0,2,0,88)
    LeftPanel.BackgroundTransparency=1; LeftPanel.BorderSizePixel=0; LeftPanel.Parent=Inner; LeftPanel.ZIndex=2
    local CatList=Instance.new("ScrollingFrame")
    CatList.Name="CategoryList"; CatList.Size=UDim2.new(1,0,1,0); CatList.BackgroundTransparency=1
    CatList.BorderSizePixel=0; CatList.CanvasSize=UDim2.new(0,0,0,0); CatList.AutomaticCanvasSize=Enum.AutomaticSize.None
    CatList.ScrollingDirection=Enum.ScrollingDirection.X; CatList.ScrollingEnabled=false; CatList.ScrollBarThickness=0; CatList.ScrollBarImageTransparency=1; CatList.ElasticBehavior=Enum.ElasticBehavior.Never
    CatList.Active=false; CatList.Parent=LeftPanel; GuiRefs.categoryList=CatList
    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,-16,1,-136); CF.Position=UDim2.new(0,8,0,134)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=4; CF.ScrollBarImageColor3=Color3.fromRGB(255,255,255); CF.ScrollBarImageTransparency=0.52
    -- The canvas follows the currently visible page.  A manual height can be
    -- stale while a page is opening/closing and is the source of mid-page
    -- stops on touch screens.
    CF.CanvasSize=UDim2.new(0,0,0,0)
    CF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    -- Let the ScrollingFrame own touch inertia.  The old velocity-killer ran
    -- while a child row was receiving the finger input, preventing swipes from
    -- reaching the bottom of long pages on phones.
    local CLay=Instance.new("UIListLayout"); CLay.SortOrder=Enum.SortOrder.LayoutOrder; CLay.Padding=UDim.new(0,6); CLay.Parent=CF
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,6); CPad.PaddingRight=UDim.new(0,6)
    CPad.PaddingTop=UDim.new(0,6); CPad.PaddingBottom=UDim.new(0,72); CPad.Parent=CF
    GuiRefs.refreshCanvas = function() end
end)()

-- Message (19) logic used by Snow's existing TP Bat controls.
SnowMessage19TPBat = SnowMessage19TPBat or {enabled=false, connection=nil, hitCooldown=false}
local Message19TPBat = SnowMessage19TPBat
if Message19TPBat.connection then pcall(function() Message19TPBat.connection:Disconnect() end); Message19TPBat.connection=nil end
Message19TPBat.enabled=false

local function message19FindBat()
    local character=LP.Character
    if not character then return nil end
    for _,tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local name=tool.Name:lower()
            if name:find("bat") or name:find("slap") then return tool end
        end
    end
    local backpack=LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _,tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name=tool.Name:lower()
                if name:find("bat") or name:find("slap") then
                    local humanoid=character:FindFirstChildOfClass("Humanoid")
                    if humanoid then pcall(function() humanoid:EquipTool(tool) end) end
                    return tool
                end
            end
        end
    end
end

local function message19Closest(root)
    local closest,distance=nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player~=LP and player.Character
        local targetRoot=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if targetRoot and humanoid and humanoid.Health>0 then
            local candidate=(root.Position-targetRoot.Position).Magnitude
            if candidate<distance then closest,distance=player,candidate end
        end
    end
    return closest,distance
end

local function message19Update()
    if not Message19TPBat.enabled then return end
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 then return end

    local animator=humanoid:FindFirstChildOfClass("Animator")
    if animator then pcall(function() for _,track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end end) end
    local bat=message19FindBat()
    if bat and bat.Parent~=character then pcall(function() humanoid:EquipTool(bat) end) end

    local target,distance=message19Closest(root)
    local targetRoot=target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or distance>100 then return end

    -- Preserve the working Message (19) ownership sequence verbatim.
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(nil) end end)
    task.wait()
    if not Message19TPBat.enabled or root.Parent~=character or not targetRoot.Parent then return end
    root.CFrame=CFrame.new(targetRoot.Position+Vector3.new(0,.9,0))
    root.AssemblyLinearVelocity=targetRoot.AssemblyLinearVelocity
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)

    local camera=workspace.CurrentCamera
    if camera then camera.CFrame=CFrame.new(camera.CFrame.Position,targetRoot.Position) end
    if not Message19TPBat.hitCooldown then
        Message19TPBat.hitCooldown=true
        pcall(function()
            local activeBat=message19FindBat()
            if not activeBat then return end
            activeBat:Activate()
            local remote=activeBat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then remote:FireServer() end
        end)
        task.delay(.08,function() Message19TPBat.hitCooldown=false end)
    end
    pcall(function() for _,part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end)
end

function Dragon.startTPBat()
    if Message19TPBat.enabled then return end
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
    if Dragon.clearExclusive then Dragon.clearExclusive("TP_BAT") end
    if Dragon_forceAimbotOff then Dragon_forceAimbotOff() end
    Dragon.tpBat=true
    Dragon.tpBatHittingCooldown=false
    -- TP Bat owns its Anti Die. Keep the general Protection Anti Die out of
    -- this mode so it cannot fight the network-owner movement loop.
    if Dragon.clearGlobalAntiDie then Dragon.clearGlobalAntiDie() end
    if Dragon.clearTPBatAntiDie then Dragon.clearTPBatAntiDie() end
    if Dragon.bindTPBatAntiDie then Dragon.bindTPBatAntiDie(LP.Character) end
    if Dragon._message19CharacterConnection then pcall(function() Dragon._message19CharacterConnection:Disconnect() end) end
    Dragon._message19CharacterConnection=LP.CharacterAdded:Connect(function(character)
        if Dragon.tpBat and Message19TPBat.enabled and Dragon.bindTPBatAntiDie then
            task.wait(.1)
            Dragon.bindTPBatAntiDie(character)
        end
    end)
    Message19TPBat.enabled=true
    Message19TPBat.connection=RunService.Heartbeat:Connect(message19Update)
end

function Dragon.stopTPBat()
    Dragon.tpBat=false
    Message19TPBat.enabled=false
    if Message19TPBat.connection then pcall(function() Message19TPBat.connection:Disconnect() end); Message19TPBat.connection=nil end
    if Dragon._message19CharacterConnection then pcall(function() Dragon._message19CharacterConnection:Disconnect() end); Dragon._message19CharacterConnection=nil end
    if Dragon.clearTPBatAntiDie then Dragon.clearTPBatAntiDie() end
    if antiDieEnabled and Dragon.setGlobalAntiDie then Dragon.setGlobalAntiDie(true) end
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) end
    Dragon.tpBatCurrentTarget=nil
    Dragon.tpBatHittingCooldown=false
end

-- KEYBIND SYSTEM
KeyListen={cb=nil,label=nil,active=false}
KEY_ALIASES={
    ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
    DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",
    LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
    LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
    Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
    Up="↑",Down="↓",Left="←",Right="→",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
    F9="F9",F10="F10",F11="F11",F12="F12",Minus="-",Equals="=",LeftBracket="[",RightBracket="]",
    BackSlash="\\",Semicolon=";",Quote="'",Comma=",",Period=".",Slash="/",Backquote="`",
    ButtonA="A (Pad)",ButtonB="B (Pad)",ButtonX="X (Pad)",ButtonY="Y (Pad)",
    ButtonL1="L1",ButtonR1="R1",ButtonL2="L2",ButtonR2="R2",
    ButtonL3="L3",ButtonR3="R3",ButtonStart="Start",ButtonSelect="Select",
    DPadUp="DPad ↑",DPadDown="DPad ↓",DPadLeft="DPad ←",DPadRight="DPad →",
    Thumbstick1="L Stick",Thumbstick2="R Stick"
}
function prettyKey(kc)
    if not kc then return "?" end
    local n = typeof(kc)=="EnumItem" and kc.Name or tostring(kc)
    return KEY_ALIASES[n] or n
end
local function restoreKeybindColor(label)
    if not label then return end
    if label:GetAttribute("SnowInlineKeybind") then
        label.BackgroundColor3=Color3.fromRGB(180,180,185); label.BackgroundTransparency=.48
    else
        label.BackgroundColor3=C.blue; label.BackgroundTransparency=.5
    end
end
function cancelKL()
    if KeyListen.label then
        restoreKeybindColor(KeyListen.label)
    end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
end
function startKL(lbl,onSet)
    cancelKL(); KeyListen.cb=onSet; KeyListen.label=lbl; KeyListen.active=true
    lbl.Text="..."; restoreKeybindColor(lbl)
    local cap=lbl
    task.delay(10,function()
        if KeyListen.label==cap and KeyListen.active then
            cancelKL()
            if lbl and lbl.Parent then
                -- restore previous text if possible
                restoreKeybindColor(lbl)
            end
        end
    end)
end
UIS.InputBegan:Connect(function(inp,gp)
    if not KeyListen.active then return end
    local ut=inp.UserInputType
    local isPad = ut==Enum.UserInputType.Gamepad1 or ut==Enum.UserInputType.Gamepad2
        or ut==Enum.UserInputType.Gamepad3 or ut==Enum.UserInputType.Gamepad4
    if ut~=Enum.UserInputType.Keyboard and not isPad then return end
    local k=inp.KeyCode; if k==Enum.KeyCode.Unknown then return end
    -- ignore pure stick noise
    if k==Enum.KeyCode.Thumbstick1 or k==Enum.KeyCode.Thumbstick2 then return end
    if k==Enum.KeyCode.Escape then cancelKL(); return end
    local cb=KeyListen.cb; local lb=KeyListen.label; cancelKL()
    if lb and lb.Parent then
        lb.Text=prettyKey(k)
        restoreKeybindColor(lb)
    end
    if cb then task.spawn(cb,k) end
end)

-- ROW BUILDERS
function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,26); w.BackgroundTransparency=1; w.LayoutOrder=order
    local marker=Instance.new("Frame",w); marker.Size=UDim2.new(0,3,0,16); marker.Position=UDim2.new(0,0,0,2); marker.BackgroundColor3=Color3.fromRGB(255,255,255); marker.BorderSizePixel=0; guiCorner(marker,2)
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,-10,0,20); L.Position=UDim2.new(0,10,0,0); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=C.textDim; L.TextSize=12; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end
local function enableMobileTextEntry(box)
    -- On phones, a TextBox nested in a ScrollingFrame can receive the touch
    -- without receiving focus.  Explicitly capture focus on a tap so Roblox
    -- opens the native keyboard and the value can always be edited.
    box.Active=true
    box.TextEditable=true
    box.TextXAlignment=Enum.TextXAlignment.Center
    box.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch
            or input.UserInputType==Enum.UserInputType.MouseButton1 then
            task.defer(function()
                if box.Parent and box.TextEditable then
                    box:CaptureFocus()
                end
            end)
        end
    end)
    box.Focused:Connect(function()
        if GuiRefs.contentFrame then GuiRefs.contentFrame.ScrollingEnabled=false end
    end)
    box.FocusLost:Connect(function()
        if GuiRefs.contentFrame then GuiRefs.contentFrame.ScrollingEnabled=true end
    end)
end
function addInputRow(parent,label,value,order,cb)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,46); Row.BackgroundColor3=Color3.fromRGB(0,0,0)
    Row.BackgroundTransparency=0.38; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); local rowStroke=guiStroke(Row,Color3.fromRGB(70,130,150),1); rowStroke.Transparency=0.58
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,18); Lb.Position=UDim2.new(0,12,0.5,-9)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-68,0.5,-14); BC.Size=UDim2.new(0,58,0,28)
    BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.5; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=12; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false; enableMobileTextEntry(Box)
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n and n>0 then cb(n) else Box.Text=tostring(value) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.38}) end)
    return Row,Box
end
function addDualSpeedRow(parent,label,leftName,leftValue,rightName,rightValue,order,onLeft,onRight)
    -- Taller controls keep the two speed fields easy to tap on mobile.
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,62); row.BackgroundColor3=Color3.fromRGB(0,0,0); row.BackgroundTransparency=0.38; row.BorderSizePixel=0; row.LayoutOrder=order; guiCorner(row,10); local stroke=guiStroke(row,Color3.fromRGB(70,130,150),1); stroke.Transparency=0.58
    local title=Instance.new("TextLabel",row); title.Size=UDim2.new(0.37,0,1,0); title.Position=UDim2.new(0,12,0,0); title.BackgroundTransparency=1; title.Text=label; title.TextColor3=C.text; title.TextSize=12; title.Font=Enum.Font.GothamBold; title.TextXAlignment=Enum.TextXAlignment.Left
    local function field(caption,value,x,cb)
        local cap=Instance.new("TextLabel",row); cap.Size=UDim2.new(0,68,0,16); cap.Position=UDim2.new(1,x,0,6); cap.BackgroundTransparency=1; cap.Text=caption; cap.TextColor3=C.textDim; cap.TextSize=8; cap.Font=Enum.Font.GothamBold; cap.TextXAlignment=Enum.TextXAlignment.Center
        local box=Instance.new("TextBox",row); box.Size=UDim2.new(0,68,0,32); box.Position=UDim2.new(1,x,0,24); box.BackgroundColor3=C.input; box.BackgroundTransparency=0.35; box.BorderSizePixel=0; box.Text=tostring(value); box.TextColor3=C.text; box.TextSize=12; box.Font=Enum.Font.GothamBold; box.ClearTextOnFocus=false; enableMobileTextEntry(box); guiCorner(box,7); guiStroke(box,Color3.fromRGB(55,55,60),1)
        box.FocusLost:Connect(function() local n=tonumber(box.Text); if n and n>0 then cb(n); box.Text=tostring(n) else box.Text=tostring(value) end end)
    end
    field(leftName,leftValue,-152,onLeft)
    field(rightName,rightValue,-76,onRight)
    return row
end
function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
    local hasKB=kbKey~=nil
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,46); Row.BackgroundColor3=Color3.fromRGB(0,0,0)
    Row.BackgroundTransparency=0.38; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); local rowStroke=guiStroke(Row,Color3.fromRGB(70,130,150),1); rowStroke.Transparency=0.58
    -- Keep toggle rows clean: no left-side active accent/bar.
    local ActiveLine=Instance.new("Frame",Row); ActiveLine.Name="ToggleAccentDisabled"; ActiveLine.Size=UDim2.new(0,0,1,-14); ActiveLine.Position=UDim2.new(0,1,0,7)
    ActiveLine.BackgroundColor3=C.blue; ActiveLine.BackgroundTransparency=1; ActiveLine.BorderSizePixel=0; ActiveLine.ZIndex=2; ActiveLine.Visible=false; guiCorner(ActiveLine,2)
    ActiveLine:Destroy()
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,18); Lb.Position=UDim2.new(0,12,0.5,-9)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,42,0,22); Track.Position=UDim2.new(1,-54,0.5,-11)
    Track.BackgroundColor3=enabled and C.blueDim or C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    if hasKB then addInlineKeybind(Row,kbKey,kbKey,false) end
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,18,0,18)
    Knob.Position=enabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.15 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,99)
    local st=enabled
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local function setV(on)
        st=on
        local ti=TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(Knob, ti, {
            Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
            BackgroundTransparency=on and 0.15 or 0.5
        }):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3=on and C.blueDim or C.blueDark
        }):Play()
        -- soft row flash
        TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency=0.2}):Play()
        task.delay(0.12, function()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.38}):Play()
        end)
    end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,54,0,36); Btn.Position=UDim2.new(1,-60,0.5,-18); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function()
        st=not st
        setV(st)
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.97}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
        end)
        if onToggle then onToggle(st) end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.38}) end)
    if kbKey then GuiToggleSetters[kbKey]=setV end
    return Row,setV
end

-- Compact keybind box placed beside the control it operates.  When a row has
-- an expand arrow, it sits immediately to that arrow's left.
function addInlineKeybind(row,kbName,legacyKey,leftOfArrow)
    local entry=KB and KB[kbName]
    if not row or not entry then return end
    local function caption()
        local key=entry.kb or entry.gp
        return key and prettyKey(key) or "SET"
    end
    local button=Instance.new("TextButton",row)
    button.Name="InlineKeybind_"..kbName
    button.Size=UDim2.new(0,46,0,20)
    -- Expanded rows grow downward; keep the bind beside the top arrow instead
    -- of centering it in the newly expanded height.
    if leftOfArrow=="right" then
        -- Rows without a toggle/expand arrow (such as TP Down) use the
        -- otherwise-empty right edge for their keybind.
        button.Position=UDim2.new(1,-58,0.5,-10)
    else
        button.Position=leftOfArrow and UDim2.new(1,-144,0,9) or UDim2.new(1,-108,0.5,-10)
    end
    button:SetAttribute("SnowInlineKeybind",true)
    button.BackgroundColor3=Color3.fromRGB(180,180,185); button.BackgroundTransparency=.48; button.BorderSizePixel=0
    button.AutoButtonColor=false; button.Text=caption(); button.TextColor3=C.white; button.TextSize=9; button.Font=Enum.Font.GothamBold; button.TextTruncate=Enum.TextTruncate.AtEnd
    guiCorner(button,5); guiStroke(button,Color3.fromRGB(105,105,112),1).Transparency=.18
    button.MouseButton1Click:Connect(function()
        startKL(button,function(key)
            entry.kb=key; entry.gp=nil
            if legacyKey then Keys[legacyKey]=key; _GuiKeys=Keys end
            button.Text=caption(); saveConfig()
        end)
    end)
    return button
end
-- Toggle with an expandable V1/V2 selector.  Only the chosen mode is active.
function addBatCounterModeRow(parent,order)
    local selected = batCounterMode=="V2" and 2 or 1
    local expanded=false
    local Row=Instance.new("Frame",parent); Row.Name="BatCounterMode"; Row.Size=UDim2.new(1,0,0,38)
    Row.BackgroundColor3=Color3.fromRGB(0,0,0); Row.BackgroundTransparency=0.38; Row.BorderSizePixel=0; Row.LayoutOrder=order
    Row.ClipsDescendants=true; guiCorner(Row,10); local rowStroke=guiStroke(Row,Color3.fromRGB(70,130,150),1); rowStroke.Transparency=0.58
    local ActiveLine=Instance.new("Frame",Row); ActiveLine.Size=UDim2.new(0,0,0,24); ActiveLine.Position=UDim2.new(0,1,0,7)
    ActiveLine.BackgroundColor3=C.blue; ActiveLine.BorderSizePixel=0; ActiveLine.Visible=false; guiCorner(ActiveLine,2)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.52,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text="Bat Counter"; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Arrow=Instance.new("TextButton",Row); Arrow.Size=UDim2.new(0,30,0,30); Arrow.Position=UDim2.new(1,-92,0,4)
    Arrow.BackgroundColor3=C.blueDark; Arrow.BackgroundTransparency=0.35; Arrow.BorderSizePixel=0; Arrow.Text="▼"; Arrow.TextColor3=C.text; Arrow.TextSize=12; Arrow.Font=Enum.Font.GothamBold; Arrow.AutoButtonColor=false; guiCorner(Arrow,8)
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,42,0,22); Track.Position=UDim2.new(1,-50,0,8)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,18,0,18); Knob.BorderSizePixel=0; guiCorner(Knob,99)
    local options=Instance.new("Frame",Row); options.Size=UDim2.new(1,-20,0,32); options.Position=UDim2.new(0,10,0,43); options.BackgroundTransparency=1
    local v1=Instance.new("TextButton",options); v1.Size=UDim2.new(0.5,-4,1,0); v1.Position=UDim2.new(0,0,0,0); v1.Text="V1"; v1.TextSize=10; v1.Font=Enum.Font.GothamBold; v1.BorderSizePixel=0; v1.AutoButtonColor=false; guiCorner(v1,7)
    local v2=Instance.new("TextButton",options); v2.Size=UDim2.new(0.5,-4,1,0); v2.Position=UDim2.new(0.5,4,0,0); v2.Text="V2"; v2.TextSize=10; v2.Font=Enum.Font.GothamBold; v2.BorderSizePixel=0; v2.AutoButtonColor=false; guiCorner(v2,7)
    local function isOn() return batCounterEnabled end
    local function refresh()
        local on=isOn()
        Knob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=on and 0.15 or 0.5
        Track.BackgroundColor3=on and C.blueDim or C.blueDark; ActiveLine.BackgroundTransparency=on and 0.08 or 1
        Arrow.Text=expanded and "▲" or "▼"
        for index,button in ipairs({v1,v2}) do local chosen=index==selected; button.BackgroundColor3=chosen and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=chosen and 0.1 or 0.35; button.TextColor3=chosen and C.white or C.textDim end
    end
    local function setEnabled(on)
        batCounterEnabled=on
        if on then startBatCounter() else stopBatCounter() end
        refresh(); saveConfig()
    end
    Arrow.MouseButton1Click:Connect(function()
        expanded=not expanded; Row.Size=UDim2.new(1,0,0,expanded and 82 or 38); refresh()
    end)
    local ToggleButton=Instance.new("TextButton",Track); ToggleButton.Size=UDim2.new(1,0,1,0); ToggleButton.BackgroundTransparency=1; ToggleButton.Text=""; ToggleButton.AutoButtonColor=false
    ToggleButton.MouseButton1Click:Connect(function() setEnabled(not isOn()) end)
    local function switchMode(mode) local keep=isOn(); if batCounterEnabled then stopBatCounter() end; batCounterEnabled=false; selected=mode; batCounterMode=selected==2 and "V2" or "V1"; if keep then setEnabled(true) else refresh(); saveConfig() end end
    v1.MouseButton1Click:Connect(function() switchMode(1) end); v2.MouseButton1Click:Connect(function() switchMode(2) end)
    refresh()
    return Row,setEnabled
end

-- Bat Aimbot uses the same compact expandable selector: V1/V2 plus its two options.
function addBatAimbotModeRow(parent,order)
    local selected=(aimbotMode=="BYPASS" or batV2Enabled or Dragon.batV2) and 2 or 1
    local expanded=false
    local Row=Instance.new("Frame",parent); Row.Name="BatAimbotMode"; Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=Color3.fromRGB(0,0,0); Row.BackgroundTransparency=0.38; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.ClipsDescendants=true; guiCorner(Row,10); local rowStroke=guiStroke(Row,Color3.fromRGB(70,130,150),1); rowStroke.Transparency=0.58
    local ActiveLine=Instance.new("Frame",Row); ActiveLine.Size=UDim2.new(0,0,0,24); ActiveLine.Position=UDim2.new(0,1,0,7); ActiveLine.BackgroundColor3=C.blue; ActiveLine.BorderSizePixel=0; ActiveLine.Visible=false; guiCorner(ActiveLine,2)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.52,0,0,16); Lb.Position=UDim2.new(0,12,0,6); Lb.BackgroundTransparency=1; Lb.Text="Bat Aimbot"; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Arrow=Instance.new("TextButton",Row); Arrow.Size=UDim2.new(0,30,0,30); Arrow.Position=UDim2.new(1,-92,0,4); Arrow.BackgroundColor3=C.blueDark; Arrow.BackgroundTransparency=0.35; Arrow.BorderSizePixel=0; Arrow.Text="▼"; Arrow.TextColor3=C.text; Arrow.TextSize=12; Arrow.Font=Enum.Font.GothamBold; Arrow.AutoButtonColor=false; guiCorner(Arrow,8)
    addInlineKeybind(Row,"AutoBat","circle",true)
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,42,0,22); Track.Position=UDim2.new(1,-50,0,8); Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,18,0,18); Knob.BorderSizePixel=0; guiCorner(Knob,99)
    local options=Instance.new("Frame",Row); options.Size=UDim2.new(1,-20,0,304); options.Position=UDim2.new(0,10,0,43); options.BackgroundTransparency=1
    local v1=Instance.new("TextButton",options); v1.Size=UDim2.new(0.5,-4,0,30); v1.Text="NORMAL"; v1.TextSize=10; v1.Font=Enum.Font.GothamBold; v1.BorderSizePixel=0; v1.AutoButtonColor=false; guiCorner(v1,7)
    local v2=Instance.new("TextButton",options); v2.Size=UDim2.new(0.5,-4,0,30); v2.Position=UDim2.new(0.5,4,0,0); v2.Text="BYPASS"; v2.TextSize=10; v2.Font=Enum.Font.GothamBold; v2.BorderSizePixel=0; v2.AutoButtonColor=false; guiCorner(v2,7)
    local versionBar=Instance.new("Frame",options); versionBar.Size=UDim2.new(1,0,0,30); versionBar.Position=UDim2.new(0,0,0,38); versionBar.BackgroundColor3=Color3.fromRGB(22,25,30); versionBar.BackgroundTransparency=.35; versionBar.BorderSizePixel=0; guiCorner(versionBar,7)
    local av1=Instance.new("TextButton",versionBar); av1.Size=UDim2.new(1/3,-4,1,-6); av1.Position=UDim2.new(0,3,0,3); av1.Text="V1"; av1.TextSize=10; av1.Font=Enum.Font.GothamBold; av1.BorderSizePixel=0; av1.AutoButtonColor=false; guiCorner(av1,6)
    local av2=Instance.new("TextButton",versionBar); av2.Size=UDim2.new(1/3,-4,1,-6); av2.Position=UDim2.new(1/3,2,0,3); av2.Text="V2"; av2.TextSize=10; av2.Font=Enum.Font.GothamBold; av2.BorderSizePixel=0; av2.AutoButtonColor=false; guiCorner(av2,6)
    local av3=Instance.new("TextButton",versionBar); av3.Size=UDim2.new(1/3,-4,1,-6); av3.Position=UDim2.new(2/3,1,0,3); av3.Text="V3"; av3.TextSize=10; av3.Font=Enum.Font.GothamBold; av3.BorderSizePixel=0; av3.AutoButtonColor=false; guiCorner(av3,6)
    local function makeSpeedRow(label,y,getValue,setValue)
        local speedRow=Instance.new("Frame",options); speedRow.Size=UDim2.new(1,0,0,30); speedRow.Position=UDim2.new(0,0,0,y); speedRow.BackgroundColor3=Color3.fromRGB(22,25,30); speedRow.BackgroundTransparency=0.35; speedRow.BorderSizePixel=0; guiCorner(speedRow,7)
        local speedLbl=Instance.new("TextLabel",speedRow); speedLbl.Size=UDim2.new(0.72,0,1,0); speedLbl.Position=UDim2.new(0,10,0,0); speedLbl.BackgroundTransparency=1; speedLbl.Text=label; speedLbl.TextSize=8; speedLbl.Font=Enum.Font.GothamBold; speedLbl.TextColor3=C.text; speedLbl.TextXAlignment=Enum.TextXAlignment.Left
        local speedBox=Instance.new("TextBox",speedRow); speedBox.Size=UDim2.new(0,48,0,20); speedBox.Position=UDim2.new(1,-56,0.5,-10); speedBox.BackgroundColor3=Color3.fromRGB(5,5,7); speedBox.BackgroundTransparency=0.15; speedBox.BorderSizePixel=0; speedBox.Text=tostring(getValue()); speedBox.TextColor3=C.text; speedBox.TextSize=10; speedBox.Font=Enum.Font.GothamBold; speedBox.ClearTextOnFocus=false; enableMobileTextEntry(speedBox); guiCorner(speedBox,6)
        speedBox.FocusLost:Connect(function() local value=math.clamp(tonumber(speedBox.Text) or getValue(),1,200); setValue(value); speedBox.Text=tostring(value); saveConfig() end)
    end
    makeSpeedRow("AIMBOT SPEED",76,function() return AIMBOT_SPEED end,function(value) snowSetAimbotSpeed("AIMBOT",value) end)
    makeSpeedRow("AIMBOT LAGGER SPEED",114,function() return LAGGER_AIMBOT_SPEED end,function(value) snowSetAimbotSpeed("AIMBOT_LAGGER",value) end)
    makeSpeedRow("BYPASS SPEED",152,function() return BYPASS_AIMBOT_SPEED end,function(value) snowSetAimbotSpeed("BYPASS",value) end)
    makeSpeedRow("BYPASS LAGGER SPEED",190,function() return BYPASS_LAGGER_AIMBOT_SPEED end,function(value) snowSetAimbotSpeed("BYPASS_LAGGER",value) end)
    local function makeInnerToggle(label,y)
        local item=Instance.new("Frame",options); item.Size=UDim2.new(1,0,0,30); item.Position=UDim2.new(0,0,0,y); item.BackgroundColor3=Color3.fromRGB(22,25,30); item.BackgroundTransparency=0.35; item.BorderSizePixel=0; guiCorner(item,7)
        local txt=Instance.new("TextLabel",item); txt.Size=UDim2.new(0.7,0,1,0); txt.Position=UDim2.new(0,10,0,0); txt.BackgroundTransparency=1; txt.Text=label; txt.TextSize=9; txt.Font=Enum.Font.GothamBold; txt.TextColor3=C.text; txt.TextXAlignment=Enum.TextXAlignment.Left
        local track=Instance.new("Frame",item); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-50,0.5,-11); track.BorderSizePixel=0; guiCorner(track,11)
        local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,18,0,18); knob.BorderSizePixel=0; guiCorner(knob,99)
        local hit=Instance.new("TextButton",track); hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.AutoButtonColor=false
        return item,track,knob,hit
    end
    local swing,swingTrack,swingKnob,swingHit=makeInnerToggle("AUTO SWING",228)
    local mirror,mirrorTrack,mirrorKnob,mirrorHit=makeInnerToggle("MIRROR TP DOWN",266)
    local function isOn() return selected==1 and autoBatEnabled or selected==2 and (batV2Enabled or Dragon.batV2) end
    local function paint(button,on) button.BackgroundColor3=on and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=on and 0.1 or 0.35; button.TextColor3=on and C.white or C.textDim end
    local function refresh()
        local on=isOn(); Knob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=on and 0.15 or 0.5; Track.BackgroundColor3=on and C.blueDim or C.blueDark; ActiveLine.BackgroundTransparency=on and 0.08 or 1; Arrow.Text=expanded and "▲" or "▼"
        paint(v1,selected==1); paint(v2,selected==2)
        if selected==2 and aimbotBypassVersion~="V2" and aimbotBypassVersion~="V3" then aimbotBypassVersion="V1" end
        local activeVersion=selected==1 and aimbotNormalVersion or aimbotBypassVersion
        Lb.Text="Bat Aimbot"
        local bypassSelected=selected==2
        av1.Size=UDim2.new(1/3,-4,1,-6)
        av2.Size=UDim2.new(1/3,-4,1,-6)
        av2.Position=UDim2.new(1/3,2,0,3)
        av2.Visible=true
        av3.Visible=true; av3.Text="V3"
        av3.Size=UDim2.new(1/3,-4,1,-6)
        av3.Position=UDim2.new(2/3,1,0,3)
        paint(av1,activeVersion=="V1"); paint(av2,activeVersion=="V2"); paint(av3,activeVersion=="V3")
        local function paintToggle(track,knob,on) track.BackgroundColor3=on and C.blueDim or C.blueDark; track.BackgroundTransparency=0.25; knob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); knob.BackgroundColor3=C.blue; knob.BackgroundTransparency=on and 0.1 or 0.5 end
        paintToggle(swingTrack,swingKnob,autoSwingEnabled); paintToggle(mirrorTrack,mirrorKnob,mirrorTPDownEnabled)
    end
    local function setEnabled(on)
        if on and SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then refresh(); return end
        if selected==1 then
            if on and autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if on and autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            autoBatEnabled=on
            if on then queueAutoBatStart() else stopBatAimbot() end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(on) end
        else
            batV2Enabled=on
            if on then Dragon.startBatV2() else Dragon.stopBatV2() end
            if mobBtnRefs.batV2 then mobBtnRefs.batV2(on) end
        end
        refresh(); saveConfig()
    end
    Arrow.MouseButton1Click:Connect(function() expanded=not expanded; Row.Size=UDim2.new(1,0,0,expanded and 356 or 38); refresh() end)
    local ToggleButton=Instance.new("TextButton",Track); ToggleButton.Size=UDim2.new(1,0,1,0); ToggleButton.BackgroundTransparency=1; ToggleButton.Text=""; ToggleButton.AutoButtonColor=false; ToggleButton.MouseButton1Click:Connect(function() setEnabled(not isOn()) end)
    local function switchMode(mode) local keep=isOn(); if batV2Enabled or Dragon.batV2 then Dragon.stopBatV2() end; batV2Enabled=false; stopBatAimbot(); autoBatEnabled=false; selected=mode; aimbotMode=selected==1 and "AIMBOT" or "BYPASS"; if refreshMobileAimbotName then refreshMobileAimbotName() end; if keep then setEnabled(true) else refresh(); saveConfig() end end
    v1.MouseButton1Click:Connect(function() switchMode(1) end); v2.MouseButton1Click:Connect(function() switchMode(2) end)
    local function switchVersion(version)
        local keep=isOn()
        if keep then dragonStopAimbot() end
        if selected==1 then aimbotNormalVersion=version else aimbotBypassVersion=version end
        if keep then setEnabled(true) else refresh(); saveConfig() end
    end
    av1.MouseButton1Click:Connect(function() switchVersion("V1") end); av2.MouseButton1Click:Connect(function() switchVersion("V2") end); av3.MouseButton1Click:Connect(function() switchVersion("V3") end)
    swingHit.MouseButton1Click:Connect(function() autoSwingEnabled=not autoSwingEnabled; refresh(); saveConfig() end)
    mirrorHit.MouseButton1Click:Connect(function() mirrorTPDownEnabled=not mirrorTPDownEnabled; if not mirrorTPDownEnabled then pcall(function() table.clear(mirrorTPPreviousY) end) end; refresh(); saveConfig() end)
    local function setVisual()
        refresh()
    end
    refresh()
    return Row,setVisual
end
function addActionRow(parent,label,kbKey,onAction,order,keybindRight)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,42); Row.BackgroundColor3=Color3.fromRGB(0,0,0)
    Row.BackgroundTransparency=0.38; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); local rowStroke=guiStroke(Row,Color3.fromRGB(70,130,150),1); rowStroke.Transparency=0.58
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    if kbKey then addInlineKeybind(Row,kbKey,kbKey,keybindRight and "right" or false) end
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(0.55,0,1,0); AB.BackgroundTransparency=1; AB.Text=""
    AB.MouseButton1Click:Connect(function()
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.96}):Play()
        TweenService:Create(Row, TweenInfo.new(0.1), {BackgroundTransparency=0.2}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.38}):Play()
        end)
        if onAction then onAction() end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.38}) end)
    return Row
end

-- CATEGORIES
Categories={"Movement","Combat","Keybind","Misc","Settings"}
CategoryRefs={contents={},btnsSide={},active="Movement"}
;(function()
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y
        page.BackgroundTransparency=1; page.Visible=(name=="Movement"); page.Parent=GuiRefs.contentFrame
        CategoryRefs.contents[name]=page
        local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,6); lay.Parent=page
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if page.Visible and GuiRefs.refreshCanvas then
                GuiRefs.refreshCanvas()
            end
        end)
    end
    -- Compact outlined pills, proportioned like the reference GUI.
    local tabLayout={
        Movement={x=13, y=2,w=62,h=1,special=false},
        Combat  ={x=84, y=2,w=62,h=1,special=false},
        Keybind ={x=155,y=2,w=62,h=1,special=false},
        Misc    ={x=226,y=2,w=62,h=1,special=false},
        Settings={x=297,y=2,w=62,h=1,special=false},
    }
    local tabCaptions={Movement="SPEED",Combat="COMBAT",Keybind="STEAL",Misc="MISC",Settings="SETTINGS"}
    -- Keep the selected state on the tab itself: no sliding overlay between tabs.
    local TabHL=Instance.new("Frame")
    TabHL.Name="TabHighlight"
    TabHL.BackgroundTransparency=1
    TabHL.BorderSizePixel=0
    TabHL.ZIndex=1
    TabHL.Visible=false
    TabHL.Parent=GuiRefs.categoryList
    guiCorner(TabHL,8)
    local hlStroke=Instance.new("UIStroke",TabHL)
    hlStroke.Transparency=1
    local TAB_TWEEN=TweenInfo.new(0,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
    local function moveTabHL(btn)
        if not btn then return end
        TabHL.Position=btn.Position
        TabHL.Size=btn.Size
    end
    CategoryRefs.tabHL=TabHL
    CategoryRefs.moveTabHL=moveTabHL

    for i,name in ipairs(Categories) do
        local lay=tabLayout[name] or {x=0,y=0,w=82,h=1,special=false}
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(0,lay.w,lay.h,-6); btn.Position=UDim2.new(0,lay.x,0,lay.y)
        btn.BackgroundColor3=Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency=.38
        btn.Text=""
        btn.AutoButtonColor=false
        btn.BorderSizePixel=0; btn.LayoutOrder=i; btn.ZIndex=3; btn.Parent=GuiRefs.categoryList
        guiCorner(btn,9)
        local tabLabel=Instance.new("TextLabel",btn)
        tabLabel.Name="TabLabel"; tabLabel.Size=UDim2.new(1,0,1,0); tabLabel.BackgroundTransparency=1
        tabLabel.Text=tabCaptions[name] or string.upper(name); tabLabel.TextColor3=Color3.fromRGB(240,240,244); tabLabel.TextSize=8
        tabLabel.Font=Enum.Font.GothamBold; tabLabel.ZIndex=5
        local tabStroke=guiStroke(btn,(name=="Movement") and Color3.fromRGB(235,235,240) or Color3.fromRGB(80,82,91),1)
        tabStroke.Name="TabStroke"
        tabStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        tabStroke.Transparency=0
        CategoryRefs.btnsSide[name]=btn
        btn.MouseButton1Click:Connect(function()
            if CategoryRefs.active==name then return end
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            local selectedPage=CategoryRefs.contents[name]
            selectedPage.Visible=true; CategoryRefs.active=name
            selectedPage.BackgroundTransparency=1
            for n,b in pairs(CategoryRefs.btnsSide) do
                local ac=(n==name)
                b.BackgroundColor3=Color3.fromRGB(0,0,0)
                b.BackgroundTransparency=.38
                b.TextColor3=Color3.fromRGB(235,240,245)
                local label=b:FindFirstChild("TabLabel")
                if label then label.TextColor3=ac and Color3.fromRGB(255,255,255) or Color3.fromRGB(176,178,188) end
                local tabStroke=b:FindFirstChild("TabStroke")
                if tabStroke then
                    tabStroke.Color=ac and Color3.fromRGB(238,238,242) or Color3.fromRGB(80,82,91)
                    tabStroke.Transparency=0
                    tabStroke.Thickness=1
                end
            end
            moveTabHL(btn)
            task.defer(function()
                if GuiRefs.refreshCanvas then GuiRefs.refreshCanvas() end
                GuiRefs.contentFrame.CanvasPosition = Vector2.new(0, 0)
            end)
        end)
        btn.MouseEnter:Connect(function()
            if CategoryRefs.active~=name then
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=.18}):Play()
                btn.TextColor3=Color3.fromRGB(255,255,255)
            end
        end)
        btn.MouseLeave:Connect(function()
            if CategoryRefs.active~=name then
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=.38}):Play()
                btn.TextColor3=Color3.fromRGB(235,240,245)
            end
        end)
    end
    local spBtn=CategoryRefs.btnsSide["Movement"]
    if spBtn then
        spBtn.TextColor3=Color3.fromRGB(235,240,245); spBtn.BackgroundColor3=Color3.fromRGB(0,0,0); spBtn.BackgroundTransparency=.38
        local tabStroke=spBtn:FindFirstChild("TabStroke"); if tabStroke then tabStroke.Color=Color3.fromRGB(238,238,242); tabStroke.Transparency=0; tabStroke.Thickness=1 end
        local firstLabel=spBtn:FindFirstChild("TabLabel"); if firstLabel then firstLabel.TextColor3=Color3.fromRGB(255,255,255) end
        TabHL.Position=spBtn.Position
        TabHL.Size=spBtn.Size
    end
end)()

-- SPEED PAGE
;(function()
    local sp=CategoryRefs.contents["Movement"]
    addSectLbl(sp,"SPEED SYSTEM",-2)
    local speedSystemOpen=false
    local speedSystemRow=Instance.new("Frame",sp); speedSystemRow.Name="SpeedSystem"; speedSystemRow.Size=UDim2.new(1,0,0,38); speedSystemRow.BackgroundColor3=Color3.fromRGB(0,0,0); speedSystemRow.BackgroundTransparency=.38; speedSystemRow.BorderSizePixel=0; speedSystemRow.LayoutOrder=-1; speedSystemRow.ClipsDescendants=true; guiCorner(speedSystemRow,10); guiStroke(speedSystemRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local speedSystemLabel=Instance.new("TextLabel",speedSystemRow); speedSystemLabel.Size=UDim2.new(1,-54,0,16); speedSystemLabel.Position=UDim2.new(0,12,0,10); speedSystemLabel.BackgroundTransparency=1; speedSystemLabel.Text="Speed System"; speedSystemLabel.TextColor3=C.text; speedSystemLabel.TextSize=11; speedSystemLabel.Font=Enum.Font.GothamBold; speedSystemLabel.TextXAlignment=Enum.TextXAlignment.Left
    local speedSystemArrow=Instance.new("TextButton",speedSystemRow); speedSystemArrow.Size=UDim2.new(0,30,0,30); speedSystemArrow.Position=UDim2.new(1,-42,0,4); speedSystemArrow.BackgroundColor3=C.blueDark; speedSystemArrow.BackgroundTransparency=.35; speedSystemArrow.BorderSizePixel=0; speedSystemArrow.Text="▼"; speedSystemArrow.TextColor3=C.text; speedSystemArrow.TextSize=12; speedSystemArrow.Font=Enum.Font.GothamBold; speedSystemArrow.AutoButtonColor=false; guiCorner(speedSystemArrow,8)
    local speedSystemOptions=Instance.new("Frame",speedSystemRow); speedSystemOptions.Size=UDim2.new(1,-20,0,30); speedSystemOptions.Position=UDim2.new(0,10,0,43); speedSystemOptions.BackgroundTransparency=1
    local speedV1=Instance.new("TextButton",speedSystemOptions); speedV1.Size=UDim2.new(.5,-4,1,0); speedV1.BackgroundColor3=Color3.fromRGB(22,25,30); speedV1.BorderSizePixel=0; speedV1.Text="V1"; speedV1.TextColor3=C.text; speedV1.TextSize=10; speedV1.Font=Enum.Font.GothamBold; speedV1.AutoButtonColor=false; guiCorner(speedV1,7)
    local speedV2=Instance.new("TextButton",speedSystemOptions); speedV2.Size=UDim2.new(.5,-4,1,0); speedV2.Position=UDim2.new(.5,4,0,0); speedV2.BackgroundColor3=Color3.fromRGB(22,25,30); speedV2.BorderSizePixel=0; speedV2.Text="V2"; speedV2.TextColor3=C.text; speedV2.TextSize=10; speedV2.Font=Enum.Font.GothamBold; speedV2.AutoButtonColor=false; guiCorner(speedV2,7)
    local function refreshSpeedSystem()
        speedSystemArrow.Text=speedSystemOpen and "▲" or "▼"
        speedSystemRow.Size=UDim2.new(1,0,0,speedSystemOpen and 82 or 38)
        for version,button in pairs({V1=speedV1,V2=speedV2}) do
            local selected=speedSystem==version
            button.BackgroundColor3=selected and C.blueDim or Color3.fromRGB(22,25,30)
            button.BackgroundTransparency=selected and .1 or .35
            button.TextColor3=selected and C.white or C.textDim
        end
    end
    speedSystemArrow.MouseButton1Click:Connect(function() speedSystemOpen=not speedSystemOpen; refreshSpeedSystem() end)
    local function chooseSpeedSystem(version)
        if speedSystem~=version then speedSystem=version; snowClearVelocity() end
        refreshSpeedSystem(); saveConfig()
    end
    speedV1.MouseButton1Click:Connect(function() chooseSpeedSystem("V1") end)
    speedV2.MouseButton1Click:Connect(function() chooseSpeedSystem("V2") end)
    refreshSpeedSystem()
    addSectLbl(sp,"SPEED CONFIGURATION",0)
    addInputRow(sp,"Normal Speed",NS,1,function(v) NS=v; saveConfig() end)
    addInputRow(sp,"Carry Speed",CS,2,function(v) CS=v; saveConfig() end)
    addSectLbl(sp,"LAGGER SPEED CONFIGURATION",2.5)
    addInputRow(sp,"Lagger Normal Speed",LAGGER_SPEED,3,function(v) LAGGER_SPEED=v; saveConfig() end)
    addInputRow(sp,"Lagger Carry Speed",LAGGER_CARRY_SPEED,3.5,function(v) LAGGER_CARRY_SPEED=v; saveConfig() end)
    addSectLbl(sp,"AUTO",4)
    local carryOpen=false
    local carryRow=Instance.new("Frame",sp); carryRow.Name="AutoCarry"; carryRow.Size=UDim2.new(1,0,0,38); carryRow.BackgroundColor3=Color3.fromRGB(0,0,0); carryRow.BackgroundTransparency=.38; carryRow.BorderSizePixel=0; carryRow.LayoutOrder=5; carryRow.ClipsDescendants=true; guiCorner(carryRow,10); guiStroke(carryRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local carryLabel=Instance.new("TextLabel",carryRow); carryLabel.Size=UDim2.new(.52,0,0,16); carryLabel.Position=UDim2.new(0,12,0,6); carryLabel.BackgroundTransparency=1; carryLabel.Text="Auto Carry"; carryLabel.TextColor3=C.text; carryLabel.TextSize=11; carryLabel.Font=Enum.Font.GothamBold; carryLabel.TextXAlignment=Enum.TextXAlignment.Left
    local carryArrow=Instance.new("TextButton",carryRow); carryArrow.Size=UDim2.new(0,30,0,30); carryArrow.Position=UDim2.new(1,-92,0,4); carryArrow.BackgroundColor3=C.blueDark; carryArrow.BorderSizePixel=0; carryArrow.Text="▼"; carryArrow.TextColor3=C.text; carryArrow.Font=Enum.Font.GothamBold; carryArrow.TextSize=12; guiCorner(carryArrow,8)
    local carryTrack=Instance.new("Frame",carryRow); carryTrack.Size=UDim2.new(0,42,0,22); carryTrack.Position=UDim2.new(1,-50,0,8); carryTrack.BorderSizePixel=0; guiCorner(carryTrack,10)
    local carryKnob=Instance.new("Frame",carryTrack); carryKnob.Size=UDim2.new(0,18,0,18); carryKnob.BorderSizePixel=0; guiCorner(carryKnob,99)
    local carryOptions=Instance.new("Frame",carryRow); carryOptions.Size=UDim2.new(1,-20,0,70); carryOptions.Position=UDim2.new(0,10,0,43); carryOptions.BackgroundTransparency=1
    local pickup=Instance.new("TextButton",carryOptions); pickup.Size=UDim2.new(.5,-4,0,30); pickup.Text="ON PICKUP"; pickup.Font=Enum.Font.GothamBold; pickup.TextSize=9; pickup.BorderSizePixel=0; guiCorner(pickup,7)
    local near=Instance.new("TextButton",carryOptions); near.Size=UDim2.new(.5,-4,0,30); near.Position=UDim2.new(.5,4,0,0); near.Text="WHEN NEAR"; near.Font=Enum.Font.GothamBold; near.TextSize=9; near.BorderSizePixel=0; guiCorner(near,7)
    local rangeLabel=Instance.new("TextLabel",carryOptions); rangeLabel.Size=UDim2.new(.65,0,0,30); rangeLabel.Position=UDim2.new(0,10,0,38); rangeLabel.BackgroundTransparency=1; rangeLabel.Text="STEAL RANGE"; rangeLabel.TextColor3=C.text; rangeLabel.TextSize=9; rangeLabel.Font=Enum.Font.GothamBold; rangeLabel.TextXAlignment=Enum.TextXAlignment.Left
    local rangeBox=Instance.new("TextBox",carryOptions); rangeBox.Size=UDim2.new(0,58,0,22); rangeBox.Position=UDim2.new(1,-66,0,42); rangeBox.BackgroundColor3=Color3.fromRGB(5,5,7); rangeBox.BorderSizePixel=0; rangeBox.Text=tostring(autoCarryStealRange); rangeBox.TextColor3=C.text; rangeBox.TextSize=10; rangeBox.Font=Enum.Font.GothamBold; rangeBox.ClearTextOnFocus=false; enableMobileTextEntry(rangeBox); guiCorner(rangeBox,6)
    local function refreshCarry() local on=autoSwitchSpeedEnabled; carryArrow.Text=carryOpen and "▲" or "▼"; carryTrack.BackgroundColor3=on and C.blueDim or C.blueDark; carryKnob.Position=on and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9); carryKnob.BackgroundColor3=C.blue; carryKnob.BackgroundTransparency=on and .15 or .5; for mode,button in pairs({ON_PICKUP=pickup,WHEN_NEAR=near}) do local selected=autoCarryMode==mode; button.BackgroundColor3=selected and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=selected and .1 or .35; button.TextColor3=selected and C.white or C.textDim end; local visible=autoCarryMode=="WHEN_NEAR"; rangeLabel.Visible=visible; rangeBox.Visible=visible; carryRow.Size=UDim2.new(1,0,0,carryOpen and (visible and 121 or 82) or 38) end
    local carryToggle=Instance.new("TextButton",carryTrack); carryToggle.Size=UDim2.new(1,0,1,0); carryToggle.BackgroundTransparency=1; carryToggle.Text=""; carryToggle.MouseButton1Click:Connect(function() autoSwitchSpeedEnabled=not autoSwitchSpeedEnabled; _autoSwitchWasSteal=false; if autoSwitchSpeedEnabled then updateAutoSwitchSpeed() end; refreshCarry(); saveConfig() end)
    carryArrow.MouseButton1Click:Connect(function() carryOpen=not carryOpen; refreshCarry() end)
    pickup.MouseButton1Click:Connect(function() autoCarryMode="ON_PICKUP"; _autoSwitchWasSteal=false; refreshCarry(); saveConfig() end)
    near.MouseButton1Click:Connect(function() autoCarryMode="WHEN_NEAR"; _autoSwitchWasSteal=false; if autoSwitchSpeedEnabled then updateAutoSwitchSpeed() end; refreshCarry(); saveConfig() end)
    rangeBox.FocusLost:Connect(function() autoCarryStealRange=math.clamp(tonumber(rangeBox.Text) or autoCarryStealRange,1,200); rangeBox.Text=tostring(autoCarryStealRange); if autoSwitchSpeedEnabled then updateAutoSwitchSpeed() end; saveConfig() end)
    refreshCarry()
    addSectLbl(sp,"CONTROLS",6)
    addToggleRow(sp,"Carry Mode",carrySpeedActive,7,"SpeedToggle",function(on)
        Dragon.setExclusiveSpeed(on and "CARRY" or "NORMAL")
        saveConfig()
    end)
    addToggleRow(sp,"Lagger Mode",laggerModeEnabled,8,"LaggerToggle",function(on)
        Dragon.setExclusiveSpeed(on and "LAGGER_NORMAL" or "NORMAL"); saveConfig()
    end)
end)()

-- COMBAT PAGE
;(function()
    local cp=CategoryRefs.contents["Combat"]
    addSectLbl(cp,"BAT CONTROLS",0)
    local _,svAutoBat=addBatAimbotModeRow(cp,2)
    autoBatSetVisual=svAutoBat
    local _,svBatCounter=addBatCounterModeRow(cp,4)
    setBatCounterVisual=svBatCounter
    addSectLbl(cp,"BODY LOCK",6)
    local bodyLockRow,svBodyLock=addToggleRow(cp,"Body Lock",Dragon.bodyLock,7,nil,function(on)
        Dragon.forceHitBodyLock=false; Dragon.setBodyLock(on==true); saveConfig()
    end)
    bodyLockRow.Size=UDim2.new(1,0,0,38); bodyLockRow.ClipsDescendants=true
    for _,child in ipairs(bodyLockRow:GetChildren()) do
        if child:IsA("TextLabel") and child.Text=="Body Lock" then child.Position=UDim2.new(0,12,0,6) end
        if child:IsA("Frame") and child.Size.X.Offset==42 and child.Size.Y.Offset==22 then child.Position=UDim2.new(1,-54,0,8) end
    end
    local bodyLockOpen=false
    local bodyLockArrow=Instance.new("TextButton",bodyLockRow); bodyLockArrow.Size=UDim2.new(0,30,0,30); bodyLockArrow.Position=UDim2.new(1,-92,0,4); bodyLockArrow.BackgroundColor3=C.blueDark; bodyLockArrow.BackgroundTransparency=.35; bodyLockArrow.BorderSizePixel=0; bodyLockArrow.Text="▼"; bodyLockArrow.TextColor3=C.text; bodyLockArrow.TextSize=12; bodyLockArrow.Font=Enum.Font.GothamBold; bodyLockArrow.AutoButtonColor=false; guiCorner(bodyLockArrow,8)
    local bodyLockToggleHit=Instance.new("TextButton",bodyLockRow); bodyLockToggleHit.Size=UDim2.new(0,42,0,22); bodyLockToggleHit.Position=UDim2.new(1,-54,0,8); bodyLockToggleHit.BackgroundTransparency=1; bodyLockToggleHit.Text=""; bodyLockToggleHit.AutoButtonColor=false
    bodyLockToggleHit.MouseButton1Click:Connect(function() Dragon.forceHitBodyLock=false; Dragon.setBodyLock(not Dragon.bodyLock); svBodyLock(Dragon.bodyLock); saveConfig() end)
    local bodyMode=Instance.new("Frame",bodyLockRow); bodyMode.Size=UDim2.new(1,-20,0,27); bodyMode.Position=UDim2.new(0,10,0,42); bodyMode.BackgroundTransparency=1
    local bodyPerm=Instance.new("TextButton",bodyMode); bodyPerm.Size=UDim2.new(.5,-4,1,0); bodyPerm.Text="PERM"; bodyPerm.TextSize=10; bodyPerm.Font=Enum.Font.GothamBold; bodyPerm.BorderSizePixel=0; bodyPerm.AutoButtonColor=false; guiCorner(bodyPerm,7)
    local bodyRadius=Instance.new("TextButton",bodyMode); bodyRadius.Size=UDim2.new(.5,-4,1,0); bodyRadius.Position=UDim2.new(.5,4,0,0); bodyRadius.Text="RADIUS"; bodyRadius.TextSize=10; bodyRadius.Font=Enum.Font.GothamBold; bodyRadius.BorderSizePixel=0; bodyRadius.AutoButtonColor=false; guiCorner(bodyRadius,7)
    local bodyLockCaption=Instance.new("TextLabel",bodyLockRow); bodyLockCaption.Size=UDim2.new(1,-20,0,13); bodyLockCaption.Position=UDim2.new(0,10,0,74); bodyLockCaption.BackgroundTransparency=1; bodyLockCaption.Text="BODY LOCK RADIUS"; bodyLockCaption.TextColor3=C.text; bodyLockCaption.TextSize=9; bodyLockCaption.Font=Enum.Font.GothamBold; bodyLockCaption.TextXAlignment=Enum.TextXAlignment.Left
    local bodyLockBox=Instance.new("TextBox",bodyLockRow); bodyLockBox.Size=UDim2.new(1,-20,0,25); bodyLockBox.Position=UDim2.new(0,10,0,88); bodyLockBox.BackgroundColor3=Color3.fromRGB(22,25,30); bodyLockBox.BackgroundTransparency=.35; bodyLockBox.BorderSizePixel=0; bodyLockBox.Text=tostring(Dragon.bodyLockRange); bodyLockBox.TextColor3=C.text; bodyLockBox.TextSize=10; bodyLockBox.Font=Enum.Font.GothamBold; bodyLockBox.ClearTextOnFocus=false; enableMobileTextEntry(bodyLockBox); guiCorner(bodyLockBox,7)
    local function refreshBodyMode()
        local radius=Dragon.bodyLockMode=="RADIUS"
        bodyPerm.BackgroundColor3=not radius and C.blueDim or Color3.fromRGB(22,25,30); bodyRadius.BackgroundColor3=radius and C.blueDim or Color3.fromRGB(22,25,30)
        bodyPerm.TextColor3=not radius and C.white or C.textDim; bodyRadius.TextColor3=radius and C.white or C.textDim
        bodyLockCaption.Visible=radius; bodyLockBox.Visible=radius
        bodyLockRow.Size=UDim2.new(1,0,0,bodyLockOpen and (radius and 120 or 76) or 38)
        bodyLockArrow.Text=bodyLockOpen and "▲" or "▼"
    end
    bodyLockBox.FocusLost:Connect(function() local n=tonumber(bodyLockBox.Text); Dragon.bodyLockRange=math.clamp(n or 60,1,500); bodyLockBox.Text=tostring(Dragon.bodyLockRange); saveConfig() end)
    bodyPerm.MouseButton1Click:Connect(function() Dragon.bodyLockMode="PERM"; refreshBodyMode(); saveConfig() end)
    bodyRadius.MouseButton1Click:Connect(function() Dragon.bodyLockMode="RADIUS"; refreshBodyMode(); saveConfig() end)
    bodyLockArrow.MouseButton1Click:Connect(function() bodyLockOpen=not bodyLockOpen; refreshBodyMode() end)
    refreshBodyMode()
    local bodyRangeOpen=false
    local bodyRangeRow=Instance.new("Frame",cp); bodyRangeRow.Name="BodyLockRange"; bodyRangeRow.Size=UDim2.new(1,0,0,38); bodyRangeRow.BackgroundColor3=Color3.fromRGB(0,0,0); bodyRangeRow.BackgroundTransparency=.38; bodyRangeRow.BorderSizePixel=0; bodyRangeRow.LayoutOrder=7; bodyRangeRow.ClipsDescendants=true; guiCorner(bodyRangeRow,10); guiStroke(bodyRangeRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local bodyRangeLabel=Instance.new("TextLabel",bodyRangeRow); bodyRangeLabel.Size=UDim2.new(.7,0,0,16); bodyRangeLabel.Position=UDim2.new(0,12,0,6); bodyRangeLabel.BackgroundTransparency=1; bodyRangeLabel.Text="Body Lock Range"; bodyRangeLabel.TextColor3=C.text; bodyRangeLabel.TextSize=11; bodyRangeLabel.Font=Enum.Font.GothamBold; bodyRangeLabel.TextXAlignment=Enum.TextXAlignment.Left
    local bodyRangeArrow=Instance.new("TextButton",bodyRangeRow); bodyRangeArrow.Size=UDim2.new(0,30,0,30); bodyRangeArrow.Position=UDim2.new(1,-42,0,4); bodyRangeArrow.BackgroundColor3=C.blueDark; bodyRangeArrow.BackgroundTransparency=.35; bodyRangeArrow.BorderSizePixel=0; bodyRangeArrow.Text="▼"; bodyRangeArrow.TextColor3=C.text; bodyRangeArrow.TextSize=12; bodyRangeArrow.Font=Enum.Font.GothamBold; bodyRangeArrow.AutoButtonColor=false; guiCorner(bodyRangeArrow,8)
    local bodyRangeCaption=Instance.new("TextLabel",bodyRangeRow); bodyRangeCaption.Size=UDim2.new(1,-20,0,13); bodyRangeCaption.Position=UDim2.new(0,10,0,42); bodyRangeCaption.BackgroundTransparency=1; bodyRangeCaption.Text="RANGE"; bodyRangeCaption.TextColor3=C.text; bodyRangeCaption.TextSize=9; bodyRangeCaption.Font=Enum.Font.GothamBold; bodyRangeCaption.TextXAlignment=Enum.TextXAlignment.Left
    local bodyRangeBox=Instance.new("TextBox",bodyRangeRow); bodyRangeBox.Size=UDim2.new(1,-20,0,25); bodyRangeBox.Position=UDim2.new(0,10,0,56); bodyRangeBox.BackgroundColor3=Color3.fromRGB(22,25,30); bodyRangeBox.BackgroundTransparency=.35; bodyRangeBox.BorderSizePixel=0; bodyRangeBox.Text=tostring(Dragon.bodyLockRange); bodyRangeBox.TextColor3=C.text; bodyRangeBox.TextSize=10; bodyRangeBox.Font=Enum.Font.GothamBold; bodyRangeBox.ClearTextOnFocus=false; guiCorner(bodyRangeBox,7); enableMobileTextEntry(bodyRangeBox)
    bodyRangeBox.FocusLost:Connect(function() local n=tonumber(bodyRangeBox.Text); Dragon.bodyLockRange=math.clamp(n or 60,1,500); bodyRangeBox.Text=tostring(Dragon.bodyLockRange); saveConfig() end)
    bodyRangeArrow.MouseButton1Click:Connect(function() bodyRangeOpen=not bodyRangeOpen; bodyRangeRow.Size=UDim2.new(1,0,0,bodyRangeOpen and 90 or 38); bodyRangeArrow.Text=bodyRangeOpen and "▲" or "▼" end)
    bodyRangeRow.Visible=false
    local _,svForceHit=addToggleRow(cp,"Auto Hit",Dragon.forceHit,8,nil,function(on)
        Dragon.forceHit=on==true
        if not Dragon.forceHit and Dragon.forceHitBodyLock then Dragon.forceHitBodyLock=false; Dragon.setBodyLock(false) end
        saveConfig()
    end)
    addToggleRow(cp,"Anti Ragdoll",antiRagdollEnabled,10,nil,function(on)
        antiRagdollEnabled=on==true; Dragon.antiRagdollVersion="V1"
        if antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        saveConfig()
    end)
    local _,svMedusa=addToggleRow(cp,"Medusa Counter",medusaCounterEnabled,7,nil,function(on)
        medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end; saveConfig()
    end)
    local _,svUnwalk=addToggleRow(cp,"Unwalk",unwalkEnabled,8,nil,function(on)
        unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end; saveConfig()
    end)
    addSectLbl(cp,"PROTECTION",13)
    local _,svAntiDie=addToggleRow(cp,"Anti Die",antiDieEnabled,14,nil,function(on)
        Dragon.setGlobalAntiDie(on==true); saveConfig()
    end)
    local _,svAntiKick=addToggleRow(cp,"Safe Mode",Dragon.antiKick,16,nil,function(on)
        if on then
            Dragon.enableAntiKick()
            if SafeMode and SafeMode.forceStop then SafeMode.forceStop("SAFE MODE") end
        else
            Dragon.disableAntiKick()
        end
        if Dragon.setSafeModeVisual then Dragon.setSafeModeVisual(Dragon.antiKick) end
        saveConfig()
    end)
    Dragon.setAntiKickVisual=svAntiKick
    addSectLbl(cp,"TP BAT",17)
    local tpBatRow=Instance.new("Frame",cp); tpBatRow.Name="TPBat"; tpBatRow.Size=UDim2.new(1,0,0,38); tpBatRow.BackgroundColor3=Color3.fromRGB(0,0,0); tpBatRow.BackgroundTransparency=0.38; tpBatRow.BorderSizePixel=0; tpBatRow.LayoutOrder=18; tpBatRow.ClipsDescendants=true; guiCorner(tpBatRow,10); guiStroke(tpBatRow,Color3.fromRGB(70,130,150),1).Transparency=0.58
    local tpBatLabel=Instance.new("TextLabel",tpBatRow); tpBatLabel.Size=UDim2.new(0.52,0,0,16); tpBatLabel.Position=UDim2.new(0,12,0,6); tpBatLabel.BackgroundTransparency=1; tpBatLabel.Text="TP Bat"; tpBatLabel.TextColor3=C.text; tpBatLabel.TextSize=11; tpBatLabel.Font=Enum.Font.GothamBold; tpBatLabel.TextXAlignment=Enum.TextXAlignment.Left
    local tpBatArrow=Instance.new("TextButton",tpBatRow); tpBatArrow.Size=UDim2.new(0,30,0,30); tpBatArrow.Position=UDim2.new(1,-92,0,4); tpBatArrow.BackgroundColor3=C.blueDark; tpBatArrow.BackgroundTransparency=0.35; tpBatArrow.BorderSizePixel=0; tpBatArrow.Text="▼"; tpBatArrow.TextColor3=C.text; tpBatArrow.TextSize=12; tpBatArrow.Font=Enum.Font.GothamBold; tpBatArrow.AutoButtonColor=false; guiCorner(tpBatArrow,8)
    addInlineKeybind(tpBatRow,"TPBat","tpBat",true)
    local tpBatTrack=Instance.new("Frame",tpBatRow); tpBatTrack.Size=UDim2.new(0,42,0,22); tpBatTrack.Position=UDim2.new(1,-50,0,8); tpBatTrack.BorderSizePixel=0; guiCorner(tpBatTrack,10); guiStroke(tpBatTrack,C.blueDim,1)
    local tpBatKnob=Instance.new("Frame",tpBatTrack); tpBatKnob.Size=UDim2.new(0,18,0,18); tpBatKnob.BorderSizePixel=0; guiCorner(tpBatKnob,99)
    local tpBatHit=Instance.new("TextButton",tpBatTrack); tpBatHit.Size=UDim2.new(1,0,1,0); tpBatHit.BackgroundTransparency=1; tpBatHit.Text=""; tpBatHit.AutoButtonColor=false
    local function tpOption(title,y,get,set)
        local row=Instance.new("Frame",tpBatRow); row.Size=UDim2.new(1,-20,0,30); row.Position=UDim2.new(0,10,0,y); row.BackgroundColor3=Color3.fromRGB(14,18,22); row.BackgroundTransparency=0.25; row.BorderSizePixel=0; row.Visible=false; guiCorner(row,8)
        local label=Instance.new("TextLabel",row); label.Size=UDim2.new(1,-58,1,0); label.Position=UDim2.new(0,10,0,0); label.BackgroundTransparency=1; label.Text=title; label.TextColor3=C.text; label.TextSize=10; label.Font=Enum.Font.GothamBold; label.TextXAlignment=Enum.TextXAlignment.Left
        local track=Instance.new("Frame",row); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-50,0.5,-11); track.BorderSizePixel=0; guiCorner(track,11)
        local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,18,0,18); knob.BorderSizePixel=0; guiCorner(knob,99)
        local hit=Instance.new("TextButton",track); hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.AutoButtonColor=false
        local function paint() local on=get()==true; track.BackgroundColor3=on and C.blueDim or C.blueDark; knob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); knob.BackgroundColor3=C.blue; knob.BackgroundTransparency=on and .15 or .6 end
        hit.MouseButton1Click:Connect(function() set(not get()); paint(); saveConfig() end); paint()
        return row
    end
    local tpAntiDieRow=tpOption("TP Bat Anti Die",45,function() return Dragon.tpBatAntiDie end,function(on) Dragon.tpBatAntiDie=on==true end)
    local autoOffRow=tpOption("Auto turn off on hit",79,function() return Dragon.tpBatAutoDisableOnHit end,function(on) Dragon.tpBatAutoDisableOnHit=on==true end)
    local antiVoidRow=tpOption("Anti Void",113,function() return Dragon.tpBatAntiVoid end,function(on) Dragon.tpBatAntiVoid=on==true end)
    local freeCameraRow=tpOption("Free Camera",221,function() return Dragon.tpBatFreeCamera end,function(on) Dragon.tpBatFreeCamera=on==true end); freeCameraRow.Visible=false
    local tpNoCamRow=tpOption("No Cam Collision",221,function() return Dragon.tpBatNoCamCollision end,function(on) Dragon.tpBatNoCamCollision=on==true; applyNoCamCollision() end); tpNoCamRow.Visible=false
    local tpBatExpanded=false
    local function refreshTPBat(on)
        on=on==true
        tpBatTrack.BackgroundColor3=on and C.blueDim or C.blueDark; tpBatTrack.BackgroundTransparency=0.5; tpBatKnob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); tpBatKnob.BackgroundColor3=C.blue; tpBatKnob.BackgroundTransparency=on and 0.15 or 0.5
    end
    local function setTPBat(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then refreshTPBat(false); if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end; return end
            Dragon.startTPBat()
        else Dragon.stopTPBat() end
        refreshTPBat(Dragon.tpBat); if mobBtnRefs.tpBat then mobBtnRefs.tpBat(Dragon.tpBat) end; saveConfig()
    end
    tpBatHit.MouseButton1Click:Connect(function() setTPBat(not Dragon.tpBat) end)
    tpBatArrow.MouseButton1Click:Connect(function() tpBatExpanded=not tpBatExpanded; tpAntiDieRow.Visible=tpBatExpanded; autoOffRow.Visible=tpBatExpanded; antiVoidRow.Visible=tpBatExpanded; tpBatRow.Size=UDim2.new(1,0,0,tpBatExpanded and 158 or 38); tpBatArrow.Text=tpBatExpanded and "▲" or "▼" end)
    Dragon.setTPBatVisual=function(on) refreshTPBat(on==true) end
    refreshTPBat(Dragon.tpBat)
    addSectLbl(cp,"ACTIONS",9)
    local dropOpen=false
    local dropRow=Instance.new("Frame",cp); dropRow.Name="DropBrainrot"; dropRow.Size=UDim2.new(1,0,0,42); dropRow.BackgroundColor3=Color3.fromRGB(0,0,0); dropRow.BackgroundTransparency=.38; dropRow.BorderSizePixel=0; dropRow.LayoutOrder=10; dropRow.ClipsDescendants=true; guiCorner(dropRow,10); guiStroke(dropRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local dropLabel=Instance.new("TextLabel",dropRow); dropLabel.Size=UDim2.new(0.55,0,0,16); dropLabel.Position=UDim2.new(0,12,0,8); dropLabel.BackgroundTransparency=1; dropLabel.Text="Drop Brainrot"; dropLabel.TextColor3=C.text; dropLabel.TextSize=11; dropLabel.Font=Enum.Font.GothamBold; dropLabel.TextXAlignment=Enum.TextXAlignment.Left
    local dropArrow=Instance.new("TextButton",dropRow); dropArrow.Size=UDim2.new(0,30,0,30); dropArrow.Position=UDim2.new(1,-42,0,6); dropArrow.BackgroundColor3=C.blueDark; dropArrow.BorderSizePixel=0; dropArrow.Text="▼"; dropArrow.TextColor3=C.text; dropArrow.Font=Enum.Font.GothamBold; dropArrow.TextSize=12; guiCorner(dropArrow,8)
    local dropKey=addInlineKeybind(dropRow,"DropBrainrot","dropBrainrot",true); if dropKey then dropKey.Position=UDim2.new(1,-96,0,11) end
    local dropHit=Instance.new("TextButton",dropRow); dropHit.Size=UDim2.new(1,-72,0,42); dropHit.BackgroundTransparency=1; dropHit.Text=""; dropHit.MouseButton1Click:Connect(function() runDrop() end)
    local dropOptions=Instance.new("Frame",dropRow); dropOptions.Size=UDim2.new(1,-20,0,32); dropOptions.Position=UDim2.new(0,10,0,48); dropOptions.BackgroundTransparency=1
    local jump=Instance.new("TextButton",dropOptions); jump.Size=UDim2.new(.5,-4,1,0); jump.Text="JUMP"; jump.Font=Enum.Font.GothamBold; jump.TextSize=10; jump.BorderSizePixel=0; guiCorner(jump,7)
    local stand=Instance.new("TextButton",dropOptions); stand.Size=UDim2.new(.5,-4,1,0); stand.Position=UDim2.new(.5,4,0,0); stand.Text="STAND"; stand.Font=Enum.Font.GothamBold; stand.TextSize=10; stand.BorderSizePixel=0; guiCorner(stand,7)
    local function refreshDrop() dropArrow.Text=dropOpen and "▲" or "▼"; for name,button in pairs({JUMP=jump,STAND=stand}) do local selected=dropBrainrotMode==name; button.BackgroundColor3=selected and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=selected and .1 or .35; button.TextColor3=selected and C.white or C.textDim end end
    local function chooseDrop(mode) dropBrainrotMode=mode; refreshDrop(); saveConfig() end
    dropArrow.MouseButton1Click:Connect(function() dropOpen=not dropOpen; dropRow.Size=UDim2.new(1,0,0,dropOpen and 86 or 42); refreshDrop() end)
    jump.MouseButton1Click:Connect(function() chooseDrop("JUMP") end); stand.MouseButton1Click:Connect(function() chooseDrop("STAND") end); refreshDrop()
    addActionRow(cp,"TP Down","TPFloor",function() runTPFloor() end,12,true)
    local afterOpen=false
    local afterRow=Instance.new("Frame",cp); afterRow.Name="AutoAfterDrop"; afterRow.Size=UDim2.new(1,0,0,38); afterRow.BackgroundColor3=Color3.fromRGB(0,0,0); afterRow.BackgroundTransparency=.38; afterRow.BorderSizePixel=0; afterRow.LayoutOrder=5; afterRow.ClipsDescendants=true; guiCorner(afterRow,10); guiStroke(afterRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local afterLabel=Instance.new("TextLabel",afterRow); afterLabel.Size=UDim2.new(.52,0,0,16); afterLabel.Position=UDim2.new(0,12,0,6); afterLabel.BackgroundTransparency=1; afterLabel.Text="Auto Hit After Drop"; afterLabel.TextColor3=C.text; afterLabel.TextSize=11; afterLabel.Font=Enum.Font.GothamBold; afterLabel.TextXAlignment=Enum.TextXAlignment.Left
    local afterArrow=Instance.new("TextButton",afterRow); afterArrow.Size=UDim2.new(0,30,0,30); afterArrow.Position=UDim2.new(1,-92,0,4); afterArrow.BackgroundColor3=C.blueDark; afterArrow.BackgroundTransparency=.35; afterArrow.BorderSizePixel=0; afterArrow.Text="▼"; afterArrow.TextColor3=C.text; afterArrow.TextSize=12; afterArrow.Font=Enum.Font.GothamBold; afterArrow.AutoButtonColor=false; guiCorner(afterArrow,8)
    local afterTrack=Instance.new("Frame",afterRow); afterTrack.Size=UDim2.new(0,42,0,22); afterTrack.Position=UDim2.new(1,-50,0,8); afterTrack.BorderSizePixel=0; guiCorner(afterTrack,10); guiStroke(afterTrack,C.blueDim,1)
    local afterKnob=Instance.new("Frame",afterTrack); afterKnob.Size=UDim2.new(0,18,0,18); afterKnob.BorderSizePixel=0; guiCorner(afterKnob,99)
    local afterHit=Instance.new("TextButton",afterTrack); afterHit.Size=UDim2.new(1,0,1,0); afterHit.BackgroundTransparency=1; afterHit.Text=""; afterHit.AutoButtonColor=false
    local afterOptions=Instance.new("Frame",afterRow); afterOptions.Size=UDim2.new(1,-20,0,30); afterOptions.Position=UDim2.new(0,10,0,43); afterOptions.BackgroundTransparency=1
    local afterAimbot=Instance.new("TextButton",afterOptions); afterAimbot.Size=UDim2.new(.5,-4,1,0); afterAimbot.Text="AIMBOT"; afterAimbot.TextSize=10; afterAimbot.Font=Enum.Font.GothamBold; afterAimbot.BorderSizePixel=0; afterAimbot.AutoButtonColor=false; guiCorner(afterAimbot,7)
    local afterTPBat=Instance.new("TextButton",afterOptions); afterTPBat.Size=UDim2.new(.5,-4,1,0); afterTPBat.Position=UDim2.new(.5,4,0,0); afterTPBat.Text="TP BAT"; afterTPBat.TextSize=10; afterTPBat.Font=Enum.Font.GothamBold; afterTPBat.BorderSizePixel=0; afterTPBat.AutoButtonColor=false; guiCorner(afterTPBat,7)
    local function refreshAfterDrop()
        afterArrow.Text=afterOpen and "▲" or "▼"; afterRow.Size=UDim2.new(1,0,0,afterOpen and 82 or 38)
        afterTrack.BackgroundColor3=autoAfterDropEnabled and C.blueDim or C.blueDark; afterKnob.Position=autoAfterDropEnabled and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9); afterKnob.BackgroundColor3=C.blue; afterKnob.BackgroundTransparency=autoAfterDropEnabled and .15 or .5
        for mode,button in pairs({AIMBOT=afterAimbot,TP_BAT=afterTPBat}) do local selected=autoAfterDropMode==mode; button.BackgroundColor3=selected and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=selected and .1 or .35; button.TextColor3=selected and C.white or C.textDim end
    end
    afterArrow.MouseButton1Click:Connect(function() afterOpen=not afterOpen; refreshAfterDrop() end)
    afterHit.MouseButton1Click:Connect(function() autoAfterDropEnabled=not autoAfterDropEnabled; refreshAfterDrop(); saveConfig() end)
    afterAimbot.MouseButton1Click:Connect(function() autoAfterDropMode="AIMBOT"; refreshAfterDrop(); saveConfig() end)
    afterTPBat.MouseButton1Click:Connect(function() autoAfterDropMode="TP_BAT"; refreshAfterDrop(); saveConfig() end)
    refreshAfterDrop()
end)()

-- STEAL PAGE
;(function()
    local st=CategoryRefs.contents["Keybind"]
    local barSettings=CategoryRefs.contents["Settings"]
    addSectLbl(st,"AUTO STEAL",12)
    local stealRow=Instance.new("Frame",st); stealRow.Size=UDim2.new(1,0,0,38); stealRow.BackgroundColor3=Color3.fromRGB(0,0,0); stealRow.BackgroundTransparency=0.38; stealRow.BorderSizePixel=0; stealRow.LayoutOrder=13; stealRow.ClipsDescendants=true; guiCorner(stealRow,10); guiStroke(stealRow,Color3.fromRGB(70,130,150),1).Transparency=0.58
    local stealName=Instance.new("TextLabel",stealRow); stealName.Size=UDim2.new(0.52,0,0,16); stealName.Position=UDim2.new(0,12,0,6); stealName.BackgroundTransparency=1; stealName.Text="Auto Steal"; stealName.TextColor3=C.text; stealName.TextSize=11; stealName.Font=Enum.Font.GothamBold; stealName.TextXAlignment=Enum.TextXAlignment.Left
    local stealArrow=Instance.new("TextButton",stealRow); stealArrow.Size=UDim2.new(0,30,0,30); stealArrow.Position=UDim2.new(1,-92,0,4); stealArrow.BackgroundColor3=C.blueDark; stealArrow.BackgroundTransparency=0.35; stealArrow.BorderSizePixel=0; stealArrow.Text="▼"; stealArrow.TextColor3=C.text; stealArrow.TextSize=12; stealArrow.Font=Enum.Font.GothamBold; stealArrow.AutoButtonColor=false; guiCorner(stealArrow,8)
    local stealTrack=Instance.new("Frame",stealRow); stealTrack.Size=UDim2.new(0,42,0,22); stealTrack.Position=UDim2.new(1,-50,0,8); stealTrack.BackgroundColor3=C.blueDark; stealTrack.BackgroundTransparency=0.5; stealTrack.BorderSizePixel=0; guiCorner(stealTrack,10); guiStroke(stealTrack,C.blueDim,1)
    local stealKnob=Instance.new("Frame",stealTrack); stealKnob.Size=UDim2.new(0,18,0,18); stealKnob.BorderSizePixel=0; guiCorner(stealKnob,99)
    local stealToggle=Instance.new("TextButton",stealTrack); stealToggle.Size=UDim2.new(1,0,1,0); stealToggle.BackgroundTransparency=1; stealToggle.Text=""; stealToggle.AutoButtonColor=false
    local stealOptions=Instance.new("Frame",stealRow); stealOptions.Size=UDim2.new(1,-20,0,74); stealOptions.Position=UDim2.new(0,10,0,43); stealOptions.BackgroundTransparency=1
    local modeLabel=Instance.new("TextLabel",stealOptions); modeLabel.Size=UDim2.new(1,0,0,30); modeLabel.BackgroundColor3=Color3.fromRGB(22,25,30); modeLabel.BackgroundTransparency=.1; modeLabel.BorderSizePixel=0; modeLabel.Text="NORMAL"; modeLabel.TextColor3=C.white; modeLabel.TextSize=10; modeLabel.Font=Enum.Font.GothamBold; guiCorner(modeLabel,7)
    local radius=Instance.new("TextBox",stealOptions); radius.Size=UDim2.new(1,0,0,30); radius.Position=UDim2.new(0,0,0,38); radius.BackgroundColor3=Color3.fromRGB(22,25,30); radius.BackgroundTransparency=0.35; radius.BorderSizePixel=0; radius.Text=tostring(Steal.StealRadius); radius.TextColor3=C.text; radius.TextSize=10; radius.Font=Enum.Font.GothamBold; radius.ClearTextOnFocus=false; enableMobileTextEntry(radius); guiCorner(radius,7)
    local holdRow=Instance.new("Frame",stealOptions); holdRow.Size=UDim2.new(1,0,0,30); holdRow.Position=UDim2.new(0,0,0,76); holdRow.BackgroundColor3=Color3.fromRGB(22,25,30); holdRow.BorderSizePixel=0; guiCorner(holdRow,7)
    local holdLabel=Instance.new("TextLabel",holdRow); holdLabel.Size=UDim2.new(.55,0,1,0); holdLabel.Position=UDim2.new(0,8,0,0); holdLabel.BackgroundTransparency=1; holdLabel.Text="HOLD AT"; holdLabel.TextColor3=C.white; holdLabel.TextSize=10; holdLabel.Font=Enum.Font.GothamBold; holdLabel.TextXAlignment=Enum.TextXAlignment.Left
    local holdArrow=Instance.new("TextButton",holdRow); holdArrow.Size=UDim2.new(0,24,0,24); holdArrow.Position=UDim2.new(1,-62,.5,-12); holdArrow.BackgroundColor3=C.blueDark; holdArrow.BorderSizePixel=0; holdArrow.Text="▼"; holdArrow.TextColor3=C.white; holdArrow.TextSize=10; guiCorner(holdArrow,6)
    local holdTrack=Instance.new("Frame",holdRow); holdTrack.Size=UDim2.new(0,38,0,20); holdTrack.Position=UDim2.new(1,-30,.5,-10); holdTrack.BackgroundColor3=C.blueDark; holdTrack.BorderSizePixel=0; guiCorner(holdTrack,10)
    local holdKnob=Instance.new("Frame",holdTrack); holdKnob.Size=UDim2.new(0,16,0,16); holdKnob.BackgroundColor3=C.blue; holdKnob.BorderSizePixel=0; guiCorner(holdKnob,99)
    local holdHit=Instance.new("TextButton",holdTrack); holdHit.Size=UDim2.new(1,0,1,0); holdHit.BackgroundTransparency=1; holdHit.Text=""
    local holdChoices=Instance.new("Frame",stealOptions); holdChoices.Size=UDim2.new(1,0,0,30); holdChoices.Position=UDim2.new(0,0,0,110); holdChoices.BackgroundTransparency=1; holdChoices.Visible=false
    local holdButtons={}; for i,pct in ipairs({70,80,85,90}) do local b=Instance.new("TextButton",holdChoices); b.Size=UDim2.new(.25,-3,1,0); b.Position=UDim2.new((i-1)*.25,2,0,0); b.BackgroundColor3=Color3.fromRGB(22,25,30); b.BorderSizePixel=0; b.Text=tostring(pct); b.TextColor3=C.white; b.TextSize=10; b.Font=Enum.Font.GothamBold; guiCorner(b,6); holdButtons[pct]=b end
    local ragdollSteal=Instance.new("TextButton",stealOptions); ragdollSteal.Size=UDim2.new(1,0,0,0); ragdollSteal.Visible=false; ragdollSteal.BorderSizePixel=0; ragdollSteal.AutoButtonColor=false; guiCorner(ragdollSteal,7)
    local holdMainRow=nil
    local function refreshSteal()
        stealTrack.BackgroundColor3=Steal.AutoStealEnabled and C.blueDim or C.blueDark; stealKnob.Position=Steal.AutoStealEnabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); stealKnob.BackgroundColor3=C.blue; stealKnob.BackgroundTransparency=Steal.AutoStealEnabled and 0.1 or 0.5
        modeLabel.BackgroundColor3=C.blueDim
        modeLabel.TextColor3=C.white
        ragdollSteal.BackgroundColor3=Steal.RagdollSteal and C.blueDim or Color3.fromRGB(22,25,30); ragdollSteal.TextColor3=C.white; ragdollSteal.Text=Steal.RagdollSteal and "RAGDOLL STEAL: ON" or "RAGDOLL STEAL: OFF"
        holdRow.Visible=false; holdChoices.Visible=false; holdTrack.BackgroundColor3=holdAtEnabled and C.blueDim or C.blueDark; holdKnob.Position=holdAtEnabled and UDim2.new(1,-18,.5,-8) or UDim2.new(0,2,.5,-8)
        for pct,b in pairs(holdButtons) do b.BackgroundColor3=(holdAtEnabled and (STEAL_MODE_CFG[Steal.Mode] or {}).threshold==pct/100) and C.blueDim or Color3.fromRGB(22,25,30) end
        if holdMainRow then holdMainRow.Visible=true end
    end
    local stealExpanded=false
    local function resizeStealRow() stealRow.Size=UDim2.new(1,0,0,stealExpanded and 112 or 38) end
    holdHit.MouseButton1Click:Connect(function() end)
    holdArrow.MouseButton1Click:Connect(function() end)
    for pct,b in pairs(holdButtons) do b.MouseButton1Click:Connect(function() for mode,cfg in pairs(STEAL_MODE_CFG) do if cfg.threshold==pct/100 then Steal.Mode=mode break end end; holdAtEnabled=true; holdChoices.Visible=false; holdArrow.Text="▼"; refreshSteal(); saveConfig() end) end
    ragdollSteal.MouseButton1Click:Connect(function() Steal.RagdollSteal=not Steal.RagdollSteal; refreshSteal(); saveConfig() end)
    radius.FocusLost:Connect(function() local n=tonumber(radius.Text); if n and n>0 then Steal.StealRadius=n; snowStealRadii.Normal=n end; radius.Text=tostring(Steal.StealRadius); saveConfig() end)
    stealToggle.MouseButton1Click:Connect(function() Steal.AutoStealEnabled=not Steal.AutoStealEnabled; if Steal.AutoStealEnabled then startAutoSteal() else stopAutoSteal() end; refreshSteal(); saveConfig() end)
    stealArrow.MouseButton1Click:Connect(function() stealExpanded=not stealExpanded; resizeStealRow(); stealArrow.Text=stealExpanded and "▲" or "▼" end); refreshSteal()
    -- Config restoration can finish after this page is built; repaint once on
    -- the next frame so the single Normal mode is visibly selected.
    task.defer(refreshSteal)
    -- Hold At has five fixed choices, so a left/right selector is clearer
    -- than a toggle plus a separate drop-down.
    holdMainRow=Instance.new("Frame",st); holdMainRow.Size=UDim2.new(1,0,0,46); holdMainRow.BackgroundColor3=Color3.fromRGB(0,0,0); holdMainRow.BackgroundTransparency=.38; holdMainRow.BorderSizePixel=0; holdMainRow.LayoutOrder=13.1; guiCorner(holdMainRow,10); guiStroke(holdMainRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local holdMainLabel=Instance.new("TextLabel",holdMainRow); holdMainLabel.Size=UDim2.new(.46,0,1,0); holdMainLabel.Position=UDim2.new(0,12,0,0); holdMainLabel.BackgroundTransparency=1; holdMainLabel.Text="Hold At"; holdMainLabel.TextColor3=C.text; holdMainLabel.TextSize=11; holdMainLabel.Font=Enum.Font.GothamBold; holdMainLabel.TextXAlignment=Enum.TextXAlignment.Left
    local holdPrev=Instance.new("TextButton",holdMainRow); holdPrev.Size=UDim2.new(0,28,0,28); holdPrev.Position=UDim2.new(1,-126,.5,-14); holdPrev.BackgroundTransparency=1; holdPrev.BorderSizePixel=0; holdPrev.Text="‹"; holdPrev.TextColor3=C.white; holdPrev.TextSize=22; holdPrev.Font=Enum.Font.GothamBold; holdPrev.AutoButtonColor=false
    local holdValue=Instance.new("TextLabel",holdMainRow); holdValue.Size=UDim2.new(0,62,0,26); holdValue.Position=UDim2.new(1,-96,.5,-13); holdValue.BackgroundColor3=Color3.fromRGB(25,25,29); holdValue.BackgroundTransparency=.28; holdValue.BorderSizePixel=0; holdValue.TextColor3=C.white; holdValue.TextSize=10; holdValue.Font=Enum.Font.GothamBold; guiCorner(holdValue,7)
    local holdNext=Instance.new("TextButton",holdMainRow); holdNext.Size=UDim2.new(0,28,0,28); holdNext.Position=UDim2.new(1,-32,.5,-14); holdNext.BackgroundTransparency=1; holdNext.BorderSizePixel=0; holdNext.Text="›"; holdNext.TextColor3=C.white; holdNext.TextSize=22; holdNext.Font=Enum.Font.GothamBold; holdNext.AutoButtonColor=false
    local holdValues={false,.70,.80,.85,.90}
    local function currentHoldIndex()
        if not holdAtEnabled then return 1 end
        local selected=(STEAL_MODE_CFG[Steal.Mode] or {}).threshold
        for index,value in ipairs(holdValues) do if value==selected then return index end end
        return 1
    end
    local function setHoldIndex(index)
        index=((index-1)%#holdValues)+1
        local value=holdValues[index]
        holdAtEnabled=(value~=false)
        if value then for mode,cfg in pairs(STEAL_MODE_CFG) do if cfg.threshold==value then Steal.Mode=mode; break end end end
        holdValue.Text=value and (tostring(math.floor(value*100)).."%") or "OFF"
        refreshSteal(); saveConfig()
    end
    holdPrev.MouseButton1Click:Connect(function() setHoldIndex(currentHoldIndex()-1) end)
    holdNext.MouseButton1Click:Connect(function() setHoldIndex(currentHoldIndex()+1) end)
    setHoldIndex(currentHoldIndex())
    local ragStealRow=Instance.new("Frame",st); ragStealRow.Size=UDim2.new(1,0,0,38); ragStealRow.BackgroundColor3=Color3.fromRGB(0,0,0); ragStealRow.BackgroundTransparency=.38; ragStealRow.BorderSizePixel=0; ragStealRow.LayoutOrder=13.2; ragStealRow.ClipsDescendants=true; guiCorner(ragStealRow,10); guiStroke(ragStealRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local ragStealLabel=Instance.new("TextLabel",ragStealRow); ragStealLabel.Size=UDim2.new(.55,0,0,18); ragStealLabel.Position=UDim2.new(0,12,0,10); ragStealLabel.BackgroundTransparency=1; ragStealLabel.Text="Ragdoll Steal"; ragStealLabel.TextColor3=C.text; ragStealLabel.TextSize=11; ragStealLabel.Font=Enum.Font.GothamBold; ragStealLabel.TextXAlignment=Enum.TextXAlignment.Left
    local ragStealArrow=Instance.new("TextButton",ragStealRow); ragStealArrow.Size=UDim2.new(0,30,0,30); ragStealArrow.Position=UDim2.new(1,-92,0,4); ragStealArrow.BackgroundColor3=C.blueDark; ragStealArrow.BackgroundTransparency=.35; ragStealArrow.BorderSizePixel=0; ragStealArrow.Text="▼"; ragStealArrow.TextColor3=C.text; ragStealArrow.TextSize=12; ragStealArrow.Font=Enum.Font.GothamBold; ragStealArrow.AutoButtonColor=false; guiCorner(ragStealArrow,8)
    local ragStealTrack=Instance.new("Frame",ragStealRow); ragStealTrack.Size=UDim2.new(0,42,0,22); ragStealTrack.Position=UDim2.new(1,-54,0,8); ragStealTrack.BorderSizePixel=0; guiCorner(ragStealTrack,10); guiStroke(ragStealTrack,C.blueDim,1)
    local ragStealKnob=Instance.new("Frame",ragStealTrack); ragStealKnob.Size=UDim2.new(0,18,0,18); ragStealKnob.BorderSizePixel=0; guiCorner(ragStealKnob,99)
    local ragStealHit=Instance.new("TextButton",ragStealTrack); ragStealHit.Size=UDim2.fromScale(1,1); ragStealHit.BackgroundTransparency=1; ragStealHit.Text=""; ragStealHit.AutoButtonColor=false
    local ragStealSeconds=Instance.new("TextBox",ragStealRow); ragStealSeconds.Size=UDim2.new(0,74,0,25); ragStealSeconds.Position=UDim2.new(.5,-37,0,44); ragStealSeconds.BackgroundColor3=Color3.fromRGB(22,25,30); ragStealSeconds.BackgroundTransparency=.35; ragStealSeconds.BorderSizePixel=0; ragStealSeconds.Text=tostring(Steal.RagdollStealPauseSeconds); ragStealSeconds.TextColor3=C.text; ragStealSeconds.TextSize=10; ragStealSeconds.Font=Enum.Font.GothamBold; ragStealSeconds.ClearTextOnFocus=false; enableMobileTextEntry(ragStealSeconds); guiCorner(ragStealSeconds,7)
    local ragStealOpen=false
    local function refreshRagSteal() ragStealTrack.BackgroundColor3=Steal.RagdollSteal and C.blueDim or C.blueDark; ragStealKnob.Position=Steal.RagdollSteal and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9); ragStealKnob.BackgroundColor3=C.blue; ragStealKnob.BackgroundTransparency=Steal.RagdollSteal and .1 or .5; ragStealArrow.Text=ragStealOpen and "▲" or "▼"; ragStealRow.Size=UDim2.new(1,0,0,ragStealOpen and 77 or 38) end
    ragStealSeconds.FocusLost:Connect(function() Steal.RagdollStealPauseSeconds=math.clamp(tonumber(ragStealSeconds.Text) or 1.3,.1,30); ragStealSeconds.Text=tostring(Steal.RagdollStealPauseSeconds); saveConfig() end)
    ragStealHit.MouseButton1Click:Connect(function() Steal.RagdollSteal=not Steal.RagdollSteal; refreshRagSteal(); saveConfig() end)
    ragStealArrow.MouseButton1Click:Connect(function() ragStealOpen=not ragStealOpen; refreshRagSteal() end)
    refreshRagSteal()

    addSectLbl(barSettings,"STEAL BAR SIZE",6)
    local sizeRow=Instance.new("Frame")
    sizeRow.Size=UDim2.new(1,-8,0,66)
    sizeRow.BackgroundColor3=Color3.fromRGB(0,0,0)
    sizeRow.BackgroundTransparency=0.38
    sizeRow.BorderSizePixel=0; guiCorner(sizeRow,10); guiStroke(sizeRow,Color3.fromRGB(70,130,150),1).Transparency=0.58
    sizeRow.LayoutOrder=7
    sizeRow.Parent=barSettings
    local barScaleLbl=Instance.new("TextLabel",sizeRow)
    barScaleLbl.Size=UDim2.new(1,-24,0,16); barScaleLbl.Position=UDim2.new(0,12,0,6); barScaleLbl.BackgroundTransparency=1
    barScaleLbl.Text="Steal Bar Size"; barScaleLbl.TextColor3=C.text; barScaleLbl.TextSize=11; barScaleLbl.Font=Enum.Font.GothamBold; barScaleLbl.TextXAlignment=Enum.TextXAlignment.Left

    local sizeLbl=Instance.new("TextLabel",sizeRow)
    sizeLbl.Size=UDim2.new(1,-96,0,26); sizeLbl.Position=UDim2.new(0,48,0,32)
    sizeLbl.BackgroundTransparency=1
    sizeLbl.Text=string.format("%.0f%%", (tonumber(stealBarScale) or 1)*100)
    sizeLbl.TextColor3=C.blue
    sizeLbl.Font=Enum.Font.GothamBold
    sizeLbl.TextSize=12
    sizeLbl.TextXAlignment=Enum.TextXAlignment.Center

    local function applyScale(delta)
        stealBarScale = math.clamp((tonumber(stealBarScale) or 1) + delta, 0.7, 1.8)
        sizeLbl.Text = string.format("%.0f%%", stealBarScale*100)
        saveStealBarScale()
        pcall(createStealBar)
        saveConfig()
    end
    local minusBtn=Instance.new("TextButton",sizeRow)
    minusBtn.Size=UDim2.new(0,30,0,26); minusBtn.Position=UDim2.new(0,12,0,31)
    minusBtn.BackgroundColor3=Color3.fromRGB(10,12,15); minusBtn.BackgroundTransparency=0.15
    minusBtn.BorderSizePixel=0
    minusBtn.Text="−"
    minusBtn.TextColor3=C.blue
    minusBtn.Font=Enum.Font.GothamBlack
    minusBtn.TextSize=17
    minusBtn.AutoButtonColor=false
    guiCorner(minusBtn,7); guiStroke(minusBtn,C.blueDim,1)
    minusBtn.Activated:Connect(function() applyScale(-0.1) end)

    local plusBtn=Instance.new("TextButton",sizeRow)
    plusBtn.Size=UDim2.new(0,30,0,26); plusBtn.Position=UDim2.new(1,-42,0,31)
    plusBtn.BackgroundColor3=Color3.fromRGB(10,12,15); plusBtn.BackgroundTransparency=0.15
    plusBtn.BorderSizePixel=0
    plusBtn.Text="+"
    plusBtn.TextColor3=C.blue
    plusBtn.Font=Enum.Font.GothamBlack
    plusBtn.TextSize=16
    plusBtn.AutoButtonColor=false
    guiCorner(plusBtn,7); guiStroke(plusBtn,C.blueDim,1)
    plusBtn.Activated:Connect(function() applyScale(0.1) end)

    local resetStealBar=Instance.new("TextButton",barSettings)
    resetStealBar.Size=UDim2.new(1,-8,0,42); resetStealBar.LayoutOrder=7.5; resetStealBar.BackgroundColor3=Color3.fromRGB(8,10,13); resetStealBar.BackgroundTransparency=0; resetStealBar.BorderSizePixel=0
    resetStealBar.Text="RESET STEAL BAR"; resetStealBar.TextColor3=C.white; resetStealBar.TextSize=10; resetStealBar.Font=Enum.Font.GothamBold; resetStealBar.AutoButtonColor=false; guiCorner(resetStealBar,10); guiStroke(resetStealBar,Color3.fromRGB(95,105,115),1)
    local resetStealSerial=0
    resetStealBar.MouseButton1Click:Connect(function()
        resetStealSerial=resetStealSerial+1
        local serial=resetStealSerial
        stealBarScale = 1
        saveStealBarScale()
        -- Reset is intentionally allowed even while the bar itself is locked.
        stealBarPosition = nil
        stealBarResetRequested = true
        sizeLbl.Text = "100%"
        pcall(createStealBar)
        saveConfig()
        resetStealBar.Text="DONE"
        task.delay(1,function()
            if resetStealBar and resetStealBar.Parent and resetStealSerial==serial then resetStealBar.Text="RESET STEAL BAR" end
        end)
    end)

    addSectLbl(barSettings,"STEALR IMAGE",7.7)
    local stealBgChoices=Instance.new("Frame",barSettings)
    stealBgChoices.Size=UDim2.new(1,-8,0,58); stealBgChoices.LayoutOrder=7.8; stealBgChoices.BackgroundTransparency=1; stealBgChoices.BorderSizePixel=0
    local stealBgPrev=Instance.new("TextButton",stealBgChoices); stealBgPrev.Size=UDim2.new(0,22,0,42); stealBgPrev.Position=UDim2.new(0,8,0,7); stealBgPrev.BackgroundColor3=Color3.fromRGB(13,18,22); stealBgPrev.BorderSizePixel=0; stealBgPrev.Text="‹"; stealBgPrev.TextColor3=C.blue; stealBgPrev.TextSize=28; stealBgPrev.Font=Enum.Font.GothamMedium; stealBgPrev.AutoButtonColor=false; guiCorner(stealBgPrev,8); guiStroke(stealBgPrev,Color3.fromRGB(70,130,150),1).Transparency=.35
    local stealBgNext=Instance.new("TextButton",stealBgChoices); stealBgNext.Size=UDim2.new(0,22,0,42); stealBgNext.Position=UDim2.new(1,-30,0,7); stealBgNext.BackgroundColor3=Color3.fromRGB(13,18,22); stealBgNext.BorderSizePixel=0; stealBgNext.Text="›"; stealBgNext.TextColor3=C.blue; stealBgNext.TextSize=28; stealBgNext.Font=Enum.Font.GothamMedium; stealBgNext.AutoButtonColor=false; guiCorner(stealBgNext,8); guiStroke(stealBgNext,Color3.fromRGB(70,130,150),1).Transparency=.35
    local stealBgPreview=Instance.new("Frame",stealBgChoices); stealBgPreview.Size=UDim2.new(1,-120,0,48); stealBgPreview.Position=UDim2.new(0,68,0,4); stealBgPreview.BackgroundTransparency=1; stealBgPreview.BorderSizePixel=0; stealBgPreview.ClipsDescendants=false
    local stealBgNone=Instance.new("TextButton",stealBgChoices)
    stealBgNone.Parent=stealBgPreview; stealBgNone.Size=UDim2.new(0,54,0,46); stealBgNone.Position=UDim2.new(0,0,0,1); stealBgNone.BackgroundColor3=Color3.fromRGB(9,9,11); stealBgNone.BackgroundTransparency=.15; stealBgNone.BorderSizePixel=0; stealBgNone.Text="None"; stealBgNone.TextColor3=C.white; stealBgNone.TextSize=10; stealBgNone.Font=Enum.Font.GothamBold; stealBgNone.AutoButtonColor=false; stealBgNone.ZIndex=10; guiCorner(stealBgNone,7); local stealNoneStroke=guiStroke(stealBgNone,C.white,2)
    local stealBgDefault=Instance.new("ImageButton",stealBgPreview)
    stealBgDefault.Size=UDim2.new(0,54,0,46); stealBgDefault.Position=UDim2.new(0,120,0,1); stealBgDefault.BackgroundColor3=Color3.fromRGB(9,9,11); stealBgDefault.BackgroundTransparency=.15; stealBgDefault.BorderSizePixel=0; stealBgDefault.Image="rbxassetid://113353233461769"; stealBgDefault.ScaleType=Enum.ScaleType.Crop; stealBgDefault.AutoButtonColor=false; stealBgDefault.ZIndex=5; guiCorner(stealBgDefault,7); local stealDefaultStroke=guiStroke(stealBgDefault,C.white,2)
    local stealBgN1=Instance.new("ImageButton",stealBgPreview)
    stealBgN1.Size=UDim2.new(0,54,0,46); stealBgN1.Position=UDim2.new(0,60,0,1); stealBgN1.BackgroundColor3=Color3.fromRGB(9,9,11); stealBgN1.BackgroundTransparency=.15; stealBgN1.BorderSizePixel=0; stealBgN1.Image="rbxassetid://107075935121347"; stealBgN1.ScaleType=Enum.ScaleType.Crop; stealBgN1.AutoButtonColor=false; stealBgN1.ZIndex=5; guiCorner(stealBgN1,7); local stealN1Stroke=guiStroke(stealBgN1,C.white,2)
    local stealBgCustom=Instance.new("TextBox",barSettings)
    stealBgCustom.Size=UDim2.new(1,-8,0,30); stealBgCustom.LayoutOrder=7.9; stealBgCustom.BackgroundColor3=Color3.fromRGB(20,22,26); stealBgCustom.BackgroundTransparency=.18; stealBgCustom.BorderSizePixel=0; stealBgCustom.PlaceholderText="Custom Stealr Image asset ID — press Enter"; stealBgCustom.PlaceholderColor3=Color3.fromRGB(165,170,176); stealBgCustom.Text=(stealBarBackgroundUrl or ""):gsub("rbxassetid://",""); stealBgCustom.TextColor3=C.white; stealBgCustom.TextSize=10; stealBgCustom.Font=Enum.Font.GothamBold; stealBgCustom.ClearTextOnFocus=false; enableMobileTextEntry(stealBgCustom); guiCorner(stealBgCustom,7); guiStroke(stealBgCustom,Color3.fromRGB(95,105,115),1)
    local filteringStealAsset=false
    stealBgCustom:GetPropertyChangedSignal("Text"):Connect(function()
        if filteringStealAsset then return end
        local digits=tostring(stealBgCustom.Text):gsub("%D",""):sub(1,20)
        if stealBgCustom.Text~=digits then filteringStealAsset=true; stealBgCustom.Text=digits; filteringStealAsset=false end
    end)
    local function paintStealBackgroundChoice()
        local defaultAsset="rbxassetid://113353233461769"
        local n1Asset="rbxassetid://107075935121347"
        local noneSelected=stealBarBackgroundUrl==""
        local defaultSelected=stealBarBackgroundUrl==defaultAsset
        local n1Selected=stealBarBackgroundUrl==n1Asset
        local selectedColor=SnowGetUiThemeColor()
        stealBgNone.ZIndex=noneSelected and 10 or 5; stealBgDefault.ZIndex=defaultSelected and 10 or 5; stealBgN1.ZIndex=n1Selected and 10 or 5
        stealNoneStroke.Color=selectedColor; stealNoneStroke.Thickness=2; stealNoneStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        stealDefaultStroke.Color=selectedColor; stealDefaultStroke.Thickness=2; stealDefaultStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        stealN1Stroke.Color=selectedColor; stealN1Stroke.Thickness=2; stealN1Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        stealNoneStroke.Transparency=noneSelected and 0 or 1; stealDefaultStroke.Transparency=defaultSelected and 0 or 1; stealN1Stroke.Transparency=n1Selected and 0 or 1
    end
    local function setStealBackground(asset)
        stealBarBackgroundUrl=asset or ""; stealBgCustom.Text=(stealBarBackgroundUrl or ""):gsub("rbxassetid://","")
        paintStealBackgroundChoice(); pcall(createStealBar); saveConfig()
    end
    stealBgNone.MouseButton1Click:Connect(function() setStealBackground("") end)
    stealBgDefault.MouseButton1Click:Connect(function() setStealBackground("rbxassetid://113353233461769") end)
    stealBgN1.MouseButton1Click:Connect(function() setStealBackground("rbxassetid://107075935121347") end)
    local stealBgAssets={"","rbxassetid://107075935121347","rbxassetid://113353233461769"}
    local function stepStealBackground(direction)
        local selected=1
        for index,asset in ipairs(stealBgAssets) do if stealBarBackgroundUrl==asset then selected=index; break end end
        selected=((selected-1+direction)%#stealBgAssets)+1
        setStealBackground(stealBgAssets[selected])
    end
    stealBgPrev.MouseButton1Click:Connect(function() stepStealBackground(-1) end)
    stealBgNext.MouseButton1Click:Connect(function() stepStealBackground(1) end)
    stealBgCustom.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local id=tostring(stealBgCustom.Text):match("%d+")
        if id then setStealBackground("rbxassetid://"..id) else stealBgCustom.Text=(stealBarBackgroundUrl or ""):gsub("rbxassetid://","") end
    end)
    paintStealBackgroundChoice()

    addSectLbl(barSettings,"STEAL BAR SETTINGS",7.95)
    addToggleRow(barSettings,"Lock Steal Bar",stealBarLocked,8,nil,function(on)
        stealBarLocked=on==true
        saveConfig()
    end)
    addToggleRow(barSettings,"Hide Steal Bar",stealBarHidden,8.5,nil,function(on)
        stealBarHidden=on==true
        if stealBarFrame and stealBarFrame.Parent then stealBarFrame.Visible=not stealBarHidden end
        saveConfig()
    end)

    -- Legacy Hold % controls (90 / 85 / 80 / 70); the active control is Normal V1's Hold At selector.
    local legacyHoldTitle=addSectLbl(barSettings,"HOLD AT %",8); legacyHoldTitle.Parent.Visible=false
    local pctRow=Instance.new("Frame")
    pctRow.Size=UDim2.new(1,-8,0,36)
    pctRow.BackgroundTransparency=1
    pctRow.LayoutOrder=9
    pctRow.Parent=barSettings
    pctRow.Visible=false
    local pctLay=Instance.new("UIListLayout",pctRow)
    pctLay.FillDirection=Enum.FillDirection.Horizontal
    pctLay.Padding=UDim.new(0,6)
    pctLay.HorizontalAlignment=Enum.HorizontalAlignment.Left
    pctLay.VerticalAlignment=Enum.VerticalAlignment.Center
    pctLay.SortOrder=Enum.SortOrder.LayoutOrder

    -- mode 1=90%, 2=85%, 3=80%, 4=70%
    local PCT_OPTIONS={{mode=1,label="90%"},{mode=2,label="85%"},{mode=3,label="80%"},{mode=4,label="70%"}}
    local pctBtns={}
    local function refreshPctButtons()
        for _,info in ipairs(PCT_OPTIONS) do
            local b=pctBtns[info.mode]
            if b then
                local on=(Steal.Mode==info.mode)
                b.BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(18,18,22)
                b.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
            end
        end
    end
    for i,info in ipairs(PCT_OPTIONS) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,58,0,30)
        b.BackgroundColor3=Color3.fromRGB(18,18,22)
        b.BorderSizePixel=0
        b.Text=info.label
        b.TextColor3=Color3.fromRGB(230,230,235)
        b.Font=Enum.Font.GothamBold
        b.TextSize=13
        b.AutoButtonColor=false
        b.LayoutOrder=i
        b.Parent=pctRow
        guiCorner(b,8)
        local stoke=Instance.new("UIStroke",b)
        stoke.Color=Color3.fromRGB(50,50,55)
        stoke.Thickness=1
        b.MouseButton1Click:Connect(function()
            Steal.Mode=info.mode
            refreshPctButtons()
            saveConfig()
        end)
        pctBtns[info.mode]=b
    end
    refreshPctButtons()
end)()

-- MOVEMENT PAGE
;(function()
    local mv=CategoryRefs.contents["Movement"]
    local combat=CategoryRefs.contents["Combat"]
    local autoLeftRow,svAutoLeft=addToggleRow(mv,"Auto Left",autoLeftEnabled,12,"AutoLeft",function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                return
            end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true; startAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false; stopAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local autoRightRow,svAutoRight=addToggleRow(mv,"Auto Right",autoRightEnabled,13,"AutoRight",function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                return
            end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true; startAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false; stopAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    local autoPlayRow,autoPlaySet=addToggleRow(mv,"One Autoplay Mode",autoPlayMode,11.5,nil,function(on)
        autoPlayMode=on==true
        if autoPlayMode then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
            Dragon.setAutoPlay(true)
        else
            Dragon.setAutoPlay(false)
        end
        if mobileButtonsEnabled and buildMobileButtons then buildMobileButtons() end
        saveConfig()
    end)
    autoPlayRow.Size=UDim2.new(1,0,0,38); autoPlayRow.ClipsDescendants=true
    local oneAutoArrow=Instance.new("TextButton",autoPlayRow); oneAutoArrow.Size=UDim2.new(0,30,0,30); oneAutoArrow.Position=UDim2.new(1,-92,0,4); oneAutoArrow.BackgroundColor3=C.blueDark; oneAutoArrow.BackgroundTransparency=.35; oneAutoArrow.BorderSizePixel=0; oneAutoArrow.Text="▼"; oneAutoArrow.TextColor3=C.text; oneAutoArrow.TextSize=12; oneAutoArrow.Font=Enum.Font.GothamBold; oneAutoArrow.AutoButtonColor=false; guiCorner(oneAutoArrow,8)
    local oneAutoOptions=Instance.new("Frame",autoPlayRow); oneAutoOptions.Size=UDim2.new(1,-20,0,28); oneAutoOptions.Position=UDim2.new(0,10,0,43); oneAutoOptions.BackgroundTransparency=1
    local oneAutoHalf=Instance.new("TextButton",oneAutoOptions); oneAutoHalf.Size=UDim2.new(.5,-4,1,0); oneAutoHalf.Text="HALF"; oneAutoHalf.TextSize=10; oneAutoHalf.Font=Enum.Font.GothamBold; oneAutoHalf.BorderSizePixel=0; oneAutoHalf.AutoButtonColor=false; guiCorner(oneAutoHalf,7)
    local oneAutoFull=Instance.new("TextButton",oneAutoOptions); oneAutoFull.Size=UDim2.new(.5,-4,1,0); oneAutoFull.Position=UDim2.new(.5,4,0,0); oneAutoFull.Text="FULL"; oneAutoFull.TextSize=10; oneAutoFull.Font=Enum.Font.GothamBold; oneAutoFull.BorderSizePixel=0; oneAutoFull.AutoButtonColor=false; guiCorner(oneAutoFull,7)
    local oneAutoOpen=false
    local function refreshOneAuto()
        local half=autoPlayRouteMode=="HALF"; oneAutoHalf.BackgroundColor3=half and C.blueDim or Color3.fromRGB(22,25,30); oneAutoFull.BackgroundColor3=not half and C.blueDim or Color3.fromRGB(22,25,30); oneAutoHalf.TextColor3=half and C.white or C.textDim; oneAutoFull.TextColor3=not half and C.white or C.textDim; oneAutoArrow.Text=oneAutoOpen and "▲" or "▼"; autoPlayRow.Size=UDim2.new(1,0,0,38)
    end
    oneAutoHalf.MouseButton1Click:Connect(function() autoPlayRouteMode="HALF"; if autoPlayEnabled then Dragon.setAutoPlay(true) end; refreshOneAuto(); saveConfig() end)
    oneAutoFull.MouseButton1Click:Connect(function() autoPlayRouteMode="FULL"; if autoPlayEnabled then Dragon.setAutoPlay(true) end; refreshOneAuto(); saveConfig() end)
    oneAutoArrow.MouseButton1Click:Connect(function() oneAutoOpen=not oneAutoOpen; refreshOneAuto() end)
    refreshOneAuto(); oneAutoArrow.Visible=false; oneAutoOptions.Visible=false; autoPlayRow.Visible=false
    local autoPlayRouteRow=Instance.new("Frame",mv); autoPlayRouteRow.Size=UDim2.new(1,0,0,38); autoPlayRouteRow.BackgroundColor3=Color3.fromRGB(0,0,0); autoPlayRouteRow.BackgroundTransparency=.38; autoPlayRouteRow.BorderSizePixel=0; autoPlayRouteRow.LayoutOrder=12.1; autoPlayRouteRow.Visible=false; guiCorner(autoPlayRouteRow,10); guiStroke(autoPlayRouteRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local autoPlayRouteLabel=Instance.new("TextLabel",autoPlayRouteRow); autoPlayRouteLabel.Size=UDim2.new(.42,0,1,0); autoPlayRouteLabel.Position=UDim2.new(0,12,0,0); autoPlayRouteLabel.BackgroundTransparency=1; autoPlayRouteLabel.Text="Mode"; autoPlayRouteLabel.TextColor3=C.text; autoPlayRouteLabel.TextSize=11; autoPlayRouteLabel.Font=Enum.Font.GothamBold; autoPlayRouteLabel.TextXAlignment=Enum.TextXAlignment.Left
    local autoPlayHalf=Instance.new("TextButton",autoPlayRouteRow); autoPlayHalf.Size=UDim2.new(.27,-3,0,26); autoPlayHalf.Position=UDim2.new(.46,0,.5,-13); autoPlayHalf.BorderSizePixel=0; autoPlayHalf.Text="HALF"; autoPlayHalf.TextSize=9; autoPlayHalf.Font=Enum.Font.GothamBold; autoPlayHalf.AutoButtonColor=false; guiCorner(autoPlayHalf,7)
    local autoPlayFull=Instance.new("TextButton",autoPlayRouteRow); autoPlayFull.Size=UDim2.new(.27,-3,0,26); autoPlayFull.Position=UDim2.new(.73,0,.5,-13); autoPlayFull.BorderSizePixel=0; autoPlayFull.Text="FULL"; autoPlayFull.TextSize=9; autoPlayFull.Font=Enum.Font.GothamBold; autoPlayFull.AutoButtonColor=false; guiCorner(autoPlayFull,7)
    local function refreshAutoPlayRoute()
        local half=autoPlayRouteMode=="HALF"; autoPlayHalf.BackgroundColor3=half and C.blueDim or Color3.fromRGB(22,25,30); autoPlayFull.BackgroundColor3=not half and C.blueDim or Color3.fromRGB(22,25,30); autoPlayHalf.TextColor3=half and C.white or C.textDim; autoPlayFull.TextColor3=not half and C.white or C.textDim
    end
    autoPlayHalf.MouseButton1Click:Connect(function() autoPlayRouteMode="HALF"; autoPlaySide=nil; autoPlayMode=true; Dragon.setAutoPlay(true); refreshAutoPlayRoute(); saveConfig() end)
    autoPlayFull.MouseButton1Click:Connect(function() autoPlayRouteMode="FULL"; autoPlaySide=nil; autoPlayMode=true; Dragon.setAutoPlay(true); refreshAutoPlayRoute(); saveConfig() end)
    refreshAutoPlayRoute()
    -- Restored Snow Aura V11 AutoPlay controls and behavior.
    addSectLbl(mv,"AUTO PATHS",11)
    local autoPlayClassicRow,autoPlayClassicSet=addToggleRow(mv,"MODE KEYBIND",autoPlayEnabled,12.1,"AutoPlay",function(on) Dragon.setAutoPlay(on); saveConfig() end)
    for _,child in ipairs(autoPlayClassicRow:GetChildren()) do
        if child:IsA("TextButton") and child.Text==prettyKey(KB.AutoPlay.kb) then
            child.Size=UDim2.new(0,28,0,28); child.Position=UDim2.new(1,-47,.5,-14); child.TextSize=9
        elseif child:IsA("TextButton") and child.Text=="" then
            child.Visible=false
        elseif child:IsA("Frame") and child.Size.X.Offset==42 and child.Size.Y.Offset==22 then
            child.Visible=false
        end
    end
    autoPlayClassicRow.Visible=autoPlayMode
    autoLeftRow.Visible=not autoPlayMode; autoRightRow.Visible=not autoPlayMode
    addSectLbl(combat,"MOVEMENTS",8.9)
    local tpRow=Instance.new("Frame",combat); tpRow.Size=UDim2.new(1,0,0,38); tpRow.BackgroundColor3=Color3.fromRGB(0,0,0); tpRow.BackgroundTransparency=0.38; tpRow.BorderSizePixel=0; tpRow.LayoutOrder=12.1; tpRow.ClipsDescendants=true; guiCorner(tpRow,10); guiStroke(tpRow,Color3.fromRGB(70,130,150),1).Transparency=0.58
    local tpText=Instance.new("TextLabel",tpRow); tpText.Size=UDim2.new(0.52,0,0,16); tpText.Position=UDim2.new(0,12,0,6); tpText.BackgroundTransparency=1; tpText.Text="Auto TP Down"; tpText.TextColor3=C.text; tpText.TextSize=11; tpText.Font=Enum.Font.GothamBold; tpText.TextXAlignment=Enum.TextXAlignment.Left
    local tpArrow=Instance.new("TextButton",tpRow); tpArrow.Size=UDim2.new(0,30,0,30); tpArrow.Position=UDim2.new(1,-92,0,4); tpArrow.BackgroundColor3=C.blueDark; tpArrow.BackgroundTransparency=0.35; tpArrow.BorderSizePixel=0; tpArrow.Text="▼"; tpArrow.TextColor3=C.text; tpArrow.TextSize=12; tpArrow.Font=Enum.Font.GothamBold; tpArrow.AutoButtonColor=false; guiCorner(tpArrow,8)
    local tpTrack=Instance.new("Frame",tpRow); tpTrack.Size=UDim2.new(0,42,0,22); tpTrack.Position=UDim2.new(1,-50,0,8); tpTrack.BackgroundColor3=C.blueDark; tpTrack.BackgroundTransparency=0.5; tpTrack.BorderSizePixel=0; guiCorner(tpTrack,10); guiStroke(tpTrack,C.blueDim,1)
    local tpKnob=Instance.new("Frame",tpTrack); tpKnob.Size=UDim2.new(0,18,0,18); tpKnob.BorderSizePixel=0; guiCorner(tpKnob,99)
    local tpToggle=Instance.new("TextButton",tpTrack); tpToggle.Size=UDim2.new(1,0,1,0); tpToggle.BackgroundTransparency=1; tpToggle.Text=""; tpToggle.AutoButtonColor=false
    local tpHeightLabel=Instance.new("TextLabel",tpRow); tpHeightLabel.Size=UDim2.new(1,-20,0,13); tpHeightLabel.Position=UDim2.new(0,10,0,42); tpHeightLabel.BackgroundTransparency=1; tpHeightLabel.Text="TP HEIGHT"; tpHeightLabel.TextColor3=C.text; tpHeightLabel.TextSize=9; tpHeightLabel.Font=Enum.Font.GothamBold; tpHeightLabel.TextXAlignment=Enum.TextXAlignment.Left
    local tpHeight=Instance.new("TextBox",tpRow); tpHeight.Size=UDim2.new(1,-20,0,25); tpHeight.Position=UDim2.new(0,10,0,56); tpHeight.BackgroundColor3=Color3.fromRGB(22,25,30); tpHeight.BackgroundTransparency=0.35; tpHeight.BorderSizePixel=0; tpHeight.Text=tostring(autoTPHeight); tpHeight.TextColor3=C.text; tpHeight.TextSize=10; tpHeight.Font=Enum.Font.GothamBold; tpHeight.ClearTextOnFocus=false; enableMobileTextEntry(tpHeight); guiCorner(tpHeight,7)
    local function refreshTPRow() tpTrack.BackgroundColor3=autoTPEnabled and C.blueDim or C.blueDark; tpKnob.Position=autoTPEnabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); tpKnob.BackgroundColor3=C.blue; tpKnob.BackgroundTransparency=autoTPEnabled and 0.1 or 0.5 end
    tpToggle.MouseButton1Click:Connect(function() autoTPEnabled=not autoTPEnabled; if autoTPEnabled then startAutoTP() else stopAutoTP() end; refreshTPRow(); saveConfig() end)
    tpHeight.FocusLost:Connect(function() local n=tonumber(tostring(tpHeight.Text):match("[%d%.%-]+")); if n and n>=0 and n<=500 then autoTPHeight=n end; tpHeight.Text=tostring(autoTPHeight); saveConfig() end)
    local tpExpanded=false; tpArrow.MouseButton1Click:Connect(function() tpExpanded=not tpExpanded; tpRow.Size=UDim2.new(1,0,0,tpExpanded and 90 or 38); tpArrow.Text=tpExpanded and "▲" or "▼" end); refreshTPRow()
    local downMethodRow=Instance.new("Frame",combat); downMethodRow.Name="TPDownMethodSelector"; downMethodRow.Size=UDim2.new(1,0,0,0); downMethodRow.BackgroundTransparency=1; downMethodRow.BorderSizePixel=0; downMethodRow.LayoutOrder=12.05; downMethodRow.Visible=false
    guiCorner(downMethodRow,10); guiStroke(downMethodRow,C.divider,1)
    local downMethodLabel=Instance.new("TextLabel",downMethodRow); downMethodLabel.Size=UDim2.new(1,-24,0,16); downMethodLabel.Position=UDim2.new(0,12,0,6); downMethodLabel.BackgroundTransparency=1; downMethodLabel.Text="TP DOWN METHOD"; downMethodLabel.TextColor3=C.text; downMethodLabel.TextSize=11; downMethodLabel.Font=Enum.Font.GothamBold; downMethodLabel.TextXAlignment=Enum.TextXAlignment.Left
    local downMethodValue=Instance.new("TextLabel",downMethodRow); downMethodValue.Size=UDim2.new(1,-96,0,26); downMethodValue.Position=UDim2.new(0,48,0,32); downMethodValue.BackgroundTransparency=1; downMethodValue.TextColor3=C.white; downMethodValue.TextSize=11; downMethodValue.Font=Enum.Font.GothamBold; downMethodValue.TextXAlignment=Enum.TextXAlignment.Center
    local downMethodLeft=Instance.new("TextButton",downMethodRow); downMethodLeft.Size=UDim2.new(0,30,0,26); downMethodLeft.Position=UDim2.new(0,12,0,31); downMethodLeft.BackgroundColor3=C.blueDark; downMethodLeft.BorderSizePixel=0; downMethodLeft.Text="‹"; downMethodLeft.TextColor3=C.white; downMethodLeft.TextSize=18; guiCorner(downMethodLeft,7)
    local downMethodRight=Instance.new("TextButton",downMethodRow); downMethodRight.Size=UDim2.new(0,30,0,26); downMethodRight.Position=UDim2.new(1,-42,0,31); downMethodRight.BackgroundColor3=C.blueDark; downMethodRight.BorderSizePixel=0; downMethodRight.Text="›"; downMethodRight.TextColor3=C.white; downMethodRight.TextSize=18; guiCorner(downMethodRight,7)
    local downMethods={"NORMAL","SLOW","ZIGZAG"}; local downMethodIndex=table.find(downMethods,tpDownMethod) or 1
    local function setDownMethod(index) downMethodIndex=(index-1)%#downMethods+1; tpDownMethod=downMethods[downMethodIndex]; downMethodValue.Text=(tpDownMethod=="SLOW") and "SLOWFALL" or tpDownMethod; saveConfig() end
    setDownMethod(downMethodIndex); downMethodLeft.MouseButton1Click:Connect(function() setDownMethod(downMethodIndex-1) end); downMethodRight.MouseButton1Click:Connect(function() setDownMethod(downMethodIndex+1) end)
    local infJumpRow,svInfJump=addToggleRow(combat,"Infinite Jump",infJumpEnabled,8.95,nil,function(on)
        setInfJumpInternal(on); saveConfig()
    end)
    local jumpModeRow=Instance.new("Frame",combat); jumpModeRow.Name="InfiniteJumpModeSelector"; jumpModeRow.Size=UDim2.new(1,0,0,66); jumpModeRow.BackgroundColor3=C.row; jumpModeRow.BackgroundTransparency=.5; jumpModeRow.BorderSizePixel=0; jumpModeRow.LayoutOrder=8.96; jumpModeRow.Visible=false
    guiCorner(jumpModeRow,10); guiStroke(jumpModeRow,C.divider,1)
    local jumpModeLabel=Instance.new("TextLabel",jumpModeRow); jumpModeLabel.Size=UDim2.new(1,-24,0,16); jumpModeLabel.Position=UDim2.new(0,12,0,6); jumpModeLabel.BackgroundTransparency=1; jumpModeLabel.Text="INFINITE JUMP MODE"; jumpModeLabel.TextColor3=C.text; jumpModeLabel.TextSize=11; jumpModeLabel.Font=Enum.Font.GothamBold; jumpModeLabel.TextXAlignment=Enum.TextXAlignment.Left
    local jumpHold=Instance.new("TextButton",jumpModeRow); jumpHold.Size=UDim2.new(.5,-16,0,26); jumpHold.Position=UDim2.new(0,12,0,31); jumpHold.BorderSizePixel=0; jumpHold.Text="HOLD"; jumpHold.TextSize=10; jumpHold.Font=Enum.Font.GothamBold; jumpHold.AutoButtonColor=false; guiCorner(jumpHold,7)
    local jumpManual=Instance.new("TextButton",jumpModeRow); jumpManual.Size=UDim2.new(.5,-16,0,26); jumpManual.Position=UDim2.new(.5,4,0,31); jumpManual.BorderSizePixel=0; jumpManual.Text="MANUAL"; jumpManual.TextSize=10; jumpManual.Font=Enum.Font.GothamBold; jumpManual.AutoButtonColor=false; guiCorner(jumpManual,7)
    local function setJumpMode(mode)
        infJumpMode=mode
        local hold=(mode=="hold")
        jumpHold.BackgroundColor3=hold and C.blueDim or Color3.fromRGB(22,25,30); jumpHold.BackgroundTransparency=hold and .1 or .35; jumpHold.TextColor3=hold and C.white or C.textDim
        jumpManual.BackgroundColor3=not hold and C.blueDim or Color3.fromRGB(22,25,30); jumpManual.BackgroundTransparency=not hold and .1 or .35; jumpManual.TextColor3=not hold and C.white or C.textDim
        if infJumpEnabled then setInfJumpInternal(true) end; saveConfig()
    end
    setJumpMode(tostring(infJumpMode):lower()=="hold" and "hold" or "manual"); jumpHold.MouseButton1Click:Connect(function() setJumpMode("hold") end); jumpManual.MouseButton1Click:Connect(function() setJumpMode("manual") end)
    task.defer(function() setJumpMode(tostring(infJumpMode):lower()=="hold" and "hold" or "manual") end)
    local jumpArrow=Instance.new("TextButton",infJumpRow); jumpArrow.Name="InfiniteJumpModeArrow"; jumpArrow.Size=UDim2.new(0,28,0,24); jumpArrow.Position=UDim2.new(1,-90,.5,-12); jumpArrow.BackgroundColor3=C.blueDark; jumpArrow.BorderSizePixel=0; jumpArrow.Text="▼"; jumpArrow.TextColor3=C.white; jumpArrow.TextSize=13; jumpArrow.Font=Enum.Font.GothamBold; guiCorner(jumpArrow,7)
    jumpArrow.MouseButton1Click:Connect(function() jumpModeRow.Visible=not jumpModeRow.Visible; jumpArrow.Text=jumpModeRow.Visible and "▲" or "▼" end)
    local svInstaReset
    local _,resetSetter=addToggleRow(combat,"Insta Reset",false,8.97,"InstaReset",function(on)
        if on then
            runInstaReset()
            task.delay(0.18,function() if svInstaReset then svInstaReset(false) end; setInstaResetAntiDie(false) end)
        else
            setInstaResetAntiDie(false)
        end
    end)
    svInstaReset=resetSetter
end)()


-- VISUAL PAGE
;(function()
    local vi=CategoryRefs.contents["Misc"]
    local settings=CategoryRefs.contents["Settings"]

    addSectLbl(vi,"CHARACTER",0)
    addToggleRow(vi,"Headless",headlessEnabled,1,nil,function(on)
        headlessEnabled = on == true
        pcall(function() applyHeadlessToChar(LP.Character, headlessEnabled) end)
        saveConfig()
    end)
    local korbloxRow=Instance.new("Frame",vi); korbloxRow.Name="KorbloxSelector"; korbloxRow.Size=UDim2.new(1,0,0,66); korbloxRow.BackgroundColor3=C.row; korbloxRow.BackgroundTransparency=0.5; korbloxRow.BorderSizePixel=0; korbloxRow.LayoutOrder=2
    guiCorner(korbloxRow,10); guiStroke(korbloxRow,C.divider,1)
    local korbloxLabel=Instance.new("TextLabel",korbloxRow); korbloxLabel.Size=UDim2.new(1,-24,0,16); korbloxLabel.Position=UDim2.new(0,12,0,6); korbloxLabel.BackgroundTransparency=1; korbloxLabel.Text="KORBLOX SELECTOR"; korbloxLabel.TextColor3=C.text; korbloxLabel.TextSize=11; korbloxLabel.Font=Enum.Font.GothamBold; korbloxLabel.TextXAlignment=Enum.TextXAlignment.Left
    local korbloxTrack=Instance.new("Frame",korbloxRow); korbloxTrack.Size=UDim2.new(0,42,0,22); korbloxTrack.Position=UDim2.new(1,-54,0,6); korbloxTrack.BorderSizePixel=0; guiCorner(korbloxTrack,10); guiStroke(korbloxTrack,C.blueDim,1)
    local korbloxKnob=Instance.new("Frame",korbloxTrack); korbloxKnob.Size=UDim2.new(0,18,0,18); korbloxKnob.BorderSizePixel=0; guiCorner(korbloxKnob,99)
    local korbloxToggle=Instance.new("TextButton",korbloxTrack); korbloxToggle.Size=UDim2.fromScale(1,1); korbloxToggle.BackgroundTransparency=1; korbloxToggle.Text=""; korbloxToggle.AutoButtonColor=false
    local korbloxButtons={}
    local korbloxButtonStrokes={}
    for index,mode in ipairs({"RIGHT","LEFT","BOTH"}) do
        local xOffset=(index==1 and 8) or (index==2 and 4) or 0
        local button=Instance.new("TextButton",korbloxRow); button.Size=UDim2.new(1/3,-8,0,26); button.Position=UDim2.new((index-1)/3,xOffset,0,33); button.BackgroundColor3=Color3.fromRGB(22,25,30); button.BackgroundTransparency=.35; button.BorderSizePixel=0; button.Text=mode; button.TextColor3=C.textDim; button.TextSize=9; button.Font=Enum.Font.GothamBold; button.AutoButtonColor=false; guiCorner(button,7)
        korbloxButtons[mode]=button; korbloxButtonStrokes[mode]=guiStroke(button,Color3.fromRGB(90,90,90),1); korbloxButtonStrokes[mode].Transparency=1
    end
    local function refreshKorblox()
        local on=korbloxEnabled
        korbloxTrack.BackgroundColor3=on and C.blueDim or C.blueDark; korbloxKnob.Position=on and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9); korbloxKnob.BackgroundColor3=C.blue; korbloxKnob.BackgroundTransparency=on and .15 or .5
        -- A mode is always selected visually; the toggle alone controls enable/disable.
        local selectedMode=on and korbloxMode or korbloxLastMode
        for mode,button in pairs(korbloxButtons) do
            local selected=(selectedMode==mode)
            -- Active mode: a simple gray button and plain white text, without
            -- the blue outline/glow used by some of the other selectors.
            button.BackgroundColor3=selected and Color3.fromRGB(105,105,105) or Color3.fromRGB(22,25,30)
            button.BackgroundTransparency=selected and .06 or .35
            button.TextColor3=selected and Color3.fromRGB(255,255,255) or C.textDim
            local stroke=korbloxButtonStrokes[mode]
            if stroke then stroke.Transparency=1 end
        end
    end
    local function selectKorbloxMode(mode)
        korbloxLastMode=mode
        if korbloxEnabled then
            korbloxMode=mode
            pcall(function() applyKorbloxToChar(LP.Character,korbloxMode) end)
        else
            korbloxMode="OFF"
        end
        refreshKorblox(); saveConfig()
    end
    local function setKorbloxEnabled(on)
        korbloxEnabled=on==true
        korbloxMode=korbloxEnabled and korbloxLastMode or "OFF"
        pcall(function() applyKorbloxToChar(LP.Character,korbloxMode) end)
        refreshKorblox(); saveConfig()
    end
    if korbloxMode=="RIGHT" or korbloxMode=="LEFT" or korbloxMode=="BOTH" then korbloxLastMode=korbloxMode end
    if korbloxLastMode~="RIGHT" and korbloxLastMode~="LEFT" and korbloxLastMode~="BOTH" then korbloxLastMode="RIGHT" end
    if not korbloxEnabled then korbloxMode="OFF" end
    for mode,button in pairs(korbloxButtons) do button.MouseButton1Click:Connect(function() selectKorbloxMode(mode) end) end
    korbloxToggle.MouseButton1Click:Connect(function() setKorbloxEnabled(not korbloxEnabled) end)
    refreshKorblox()
    -- A few executor/UI theme paths finish one tick later; repaint once more
    -- so the saved active mode never launches looking unselected.
    task.defer(refreshKorblox)
    task.delay(.25,refreshKorblox)
    pcall(function() applyKorbloxToChar(LP.Character,korbloxMode) end)
    addSectLbl(vi,"TOOL SKINS",2.5)
    local batSkinRow=Instance.new("Frame",vi); batSkinRow.Name="BatSkinSelector"; batSkinRow.Size=UDim2.new(1,0,0,66); batSkinRow.BackgroundColor3=C.row; batSkinRow.BackgroundTransparency=0.5; batSkinRow.BorderSizePixel=0; batSkinRow.LayoutOrder=3
    guiCorner(batSkinRow,10); guiStroke(batSkinRow,C.divider,1)
    local batSkinLabel=Instance.new("TextLabel",batSkinRow); batSkinLabel.Size=UDim2.new(1,-24,0,16); batSkinLabel.Position=UDim2.new(0,12,0,6); batSkinLabel.BackgroundTransparency=1; batSkinLabel.Text="BAT SKIN SELECTOR"; batSkinLabel.TextColor3=C.text; batSkinLabel.TextSize=11; batSkinLabel.Font=Enum.Font.GothamBold; batSkinLabel.TextXAlignment=Enum.TextXAlignment.Left
    local batSkinValue=Instance.new("TextLabel",batSkinRow); batSkinValue.Size=UDim2.new(1,-96,0,26); batSkinValue.Position=UDim2.new(0,48,0,32); batSkinValue.BackgroundTransparency=1; batSkinValue.TextColor3=C.white; batSkinValue.TextSize=11; batSkinValue.Font=Enum.Font.GothamBold; batSkinValue.TextXAlignment=Enum.TextXAlignment.Center
    local batSkinLeft=Instance.new("TextButton",batSkinRow); batSkinLeft.Size=UDim2.new(0,30,0,26); batSkinLeft.Position=UDim2.new(0,12,0,31); batSkinLeft.BackgroundColor3=Color3.fromRGB(8,10,13); batSkinLeft.BackgroundTransparency=0.15; batSkinLeft.BorderSizePixel=0; batSkinLeft.Text="‹"; batSkinLeft.TextColor3=C.white; batSkinLeft.TextSize=18; batSkinLeft.Font=Enum.Font.GothamBold; batSkinLeft.AutoButtonColor=false; guiCorner(batSkinLeft,7); guiStroke(batSkinLeft,Color3.fromRGB(95,105,115),1)
    local batSkinRight=Instance.new("TextButton",batSkinRow); batSkinRight.Size=UDim2.new(0,30,0,26); batSkinRight.Position=UDim2.new(1,-42,0,31); batSkinRight.BackgroundColor3=Color3.fromRGB(8,10,13); batSkinRight.BackgroundTransparency=0.15; batSkinRight.BorderSizePixel=0; batSkinRight.Text="›"; batSkinRight.TextColor3=C.white; batSkinRight.TextSize=18; batSkinRight.Font=Enum.Font.GothamBold; batSkinRight.AutoButtonColor=false; guiCorner(batSkinRight,7); guiStroke(batSkinRight,Color3.fromRGB(95,105,115),1)
    local batSoundsRow=addToggleRow(vi,"Bat Sounds",batSoundsEnabled,3.25,nil,function(on)
        setSnowBatSounds(on==true); saveConfig()
    end)
    local batSkinChoices={"NONE","SCYTHE","SWORD"}
    local function setBatSkin(index)
        index=(index-1)%#batSkinChoices+1; batSkinMode=batSkinChoices[index]
        batSkinValue.Text=(batSkinMode=="NONE") and "OFF" or batSkinMode
        batSoundsRow.Visible=(batSkinMode=="SWORD")
        pcall(function() applySnowBatSkin(batSkinMode) end); saveConfig()
    end
    local batSkinIndex=table.find(batSkinChoices,batSkinMode) or 1; setBatSkin(batSkinIndex)
    batSkinLeft.MouseButton1Click:Connect(function() batSkinIndex=(batSkinIndex-2)%#batSkinChoices+1; setBatSkin(batSkinIndex) end)
    batSkinRight.MouseButton1Click:Connect(function() batSkinIndex=batSkinIndex%#batSkinChoices+1; setBatSkin(batSkinIndex) end)
    local medusaSkinRow=Instance.new("Frame",vi); medusaSkinRow.Name="MedusaSkinSelector"; medusaSkinRow.Size=UDim2.new(1,0,0,66); medusaSkinRow.BackgroundColor3=C.row; medusaSkinRow.BackgroundTransparency=.5; medusaSkinRow.BorderSizePixel=0; medusaSkinRow.LayoutOrder=3.75; guiCorner(medusaSkinRow,10); guiStroke(medusaSkinRow,C.divider,1)
    local medusaSkinLabel=Instance.new("TextLabel",medusaSkinRow); medusaSkinLabel.Size=UDim2.new(1,-24,0,16); medusaSkinLabel.Position=UDim2.new(0,12,0,6); medusaSkinLabel.BackgroundTransparency=1; medusaSkinLabel.Text="MEDUSA SKIN SELECTOR"; medusaSkinLabel.TextColor3=C.text; medusaSkinLabel.TextSize=11; medusaSkinLabel.Font=Enum.Font.GothamBold; medusaSkinLabel.TextXAlignment=Enum.TextXAlignment.Left
    local medusaSkinValue=Instance.new("TextLabel",medusaSkinRow); medusaSkinValue.Size=UDim2.new(1,-96,0,26); medusaSkinValue.Position=UDim2.new(0,48,0,32); medusaSkinValue.BackgroundTransparency=1; medusaSkinValue.TextColor3=C.white; medusaSkinValue.TextSize=10; medusaSkinValue.Font=Enum.Font.GothamBold; medusaSkinValue.TextXAlignment=Enum.TextXAlignment.Center
    local medusaSkinLeft=Instance.new("TextButton",medusaSkinRow); medusaSkinLeft.Size=UDim2.new(0,30,0,26); medusaSkinLeft.Position=UDim2.new(0,12,0,31); medusaSkinLeft.BackgroundColor3=C.blueDark; medusaSkinLeft.BorderSizePixel=0; medusaSkinLeft.Text="‹"; medusaSkinLeft.TextColor3=C.white; medusaSkinLeft.TextSize=18; guiCorner(medusaSkinLeft,7)
    local medusaSkinRight=Instance.new("TextButton",medusaSkinRow); medusaSkinRight.Size=UDim2.new(0,30,0,26); medusaSkinRight.Position=UDim2.new(1,-42,0,31); medusaSkinRight.BackgroundColor3=C.blueDark; medusaSkinRight.BorderSizePixel=0; medusaSkinRight.Text="›"; medusaSkinRight.TextColor3=C.white; medusaSkinRight.TextSize=18; guiCorner(medusaSkinRight,7)
    local medusaSkinChoices={"NONE","SKULL","GOLDEN_DESERT_EAGLE"}; local medusaSkinIndex=table.find(medusaSkinChoices,medusaSkinMode) or 1
    local medusaSoundsRow
    local function setMedusaSkin(index)
        medusaSkinIndex=(index-1)%#medusaSkinChoices+1
        medusaSkinMode=medusaSkinChoices[medusaSkinIndex]
        medusaSkinValue.Text=medusaSkinMode=="NONE" and "OFF" or (medusaSkinMode=="SKULL" and "SKULL" or "GOLDEN DESERT EAGLE")
        if medusaSoundsRow then medusaSoundsRow.Visible=(medusaSkinMode=="GOLDEN_DESERT_EAGLE") end
        pcall(function() applySnowMedusaSkin(medusaSkinMode) end)
        saveConfig()
    end
    medusaSkinLeft.MouseButton1Click:Connect(function() setMedusaSkin(medusaSkinIndex-1) end); medusaSkinRight.MouseButton1Click:Connect(function() setMedusaSkin(medusaSkinIndex+1) end); setMedusaSkin(medusaSkinIndex)
    medusaSoundsRow=addToggleRow(vi,"Medusa Sounds",medusaSoundsEnabled,3.9,nil,function(on)
        setSnowMedusaSounds(on==true); saveConfig()
    end)
    medusaSoundsRow.Visible=(medusaSkinMode=="GOLDEN_DESERT_EAGLE")
    -- Legacy Panels / Speedbypass UI removed.
    local bypassPanel=Instance.new("Frame",vi); bypassPanel.Name="SnowSpeedBypassPanel"; bypassPanel.Size=UDim2.new(1,0,0,0); bypassPanel.LayoutOrder=5; bypassPanel.BackgroundTransparency=1; bypassPanel.BorderSizePixel=0; bypassPanel.Visible=false; guiCorner(bypassPanel,99)
    local bypassStroke=guiStroke(bypassPanel,Color3.fromRGB(70,130,150),1); bypassStroke.Transparency=0.52
    local bypassButton=Instance.new("TextButton",bypassPanel); bypassButton.Name="SPEEDBYPASS"; bypassButton.Size=UDim2.new(1,-8,1,-8); bypassButton.Position=UDim2.new(0,4,0,4); bypassButton.BackgroundColor3=Color3.fromRGB(14,28,38); bypassButton.BackgroundTransparency=0.12; bypassButton.BorderSizePixel=0; bypassButton.Text="SPEEDBYPASS"; bypassButton.TextColor3=C.text; bypassButton.TextSize=11; bypassButton.Font=Enum.Font.GothamBlack; bypassButton.AutoButtonColor=false; guiCorner(bypassButton,99)
    local bypassButtonStroke=guiStroke(bypassButton,Color3.fromRGB(70,130,150),1); bypassButtonStroke.Transparency=0.55
    local function paintSpeedBypass()
        local speedGui=(LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")) and (LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")):FindFirstChild("SnowSpeedBypassGui")
        local on=speedGui and speedGui.Enabled and ((speedGui:FindFirstChild("Main") and speedGui.Main.Visible) or (speedGui:FindFirstChild("SnowReopenTab") and speedGui.SnowReopenTab.Visible))
        bypassPanel.BackgroundColor3=on and Color3.fromRGB(8,30,43) or Color3.fromRGB(9,17,24)
        bypassButton.BackgroundColor3=on and Color3.fromRGB(10,48,67) or Color3.fromRGB(14,28,38)
        bypassButton.TextColor3=on and Color3.fromRGB(172,240,255) or C.text
        bypassStroke.Color=on and C.blue or Color3.fromRGB(70,130,150); bypassStroke.Transparency=on and 0.04 or 0.52; bypassStroke.Thickness=on and 2 or 1
        bypassButtonStroke.Color=on and Color3.fromRGB(120,235,255) or Color3.fromRGB(70,130,150); bypassButtonStroke.Transparency=on and 0.12 or 0.55; bypassButtonStroke.Thickness=on and 2 or 1
    end
    SnowSpeedBypass.refreshPanel=paintSpeedBypass
    bypassButton.MouseButton1Click:Connect(function()
        local playerGui=LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
        local speedGui=playerGui and playerGui:FindFirstChild("SnowSpeedBypassGui")
        local visible=speedGui and speedGui.Enabled and ((speedGui:FindFirstChild("Main") and speedGui.Main.Visible) or (speedGui:FindFirstChild("SnowReopenTab") and speedGui.SnowReopenTab.Visible))
        if visible then
            SnowSpeedBypass.setEnabled(false)
            speedGui.Enabled=false
        else
            SnowSpeedBypass.openGui()
        end
        paintSpeedBypass()
    end)
    paintSpeedBypass()
    addSectLbl(vi,"VISUAL",6)
    addToggleRow(vi,"No Cam Collision",noCamCollisionEnabled,10,nil,function(on)
        noCamCollisionEnabled=on==true; applyNoCamCollision(); saveConfig()
    end)
    addToggleRow(vi,"Hit Circle",hitCircleEnabled,11,nil,function(on)
        SnowSetHitCircle(on)
        saveConfig()
    end)
    ESP_UI_Row=Instance.new("Frame",vi); ESP_UI_Row.Name="ESP"; ESP_UI_Row.Size=UDim2.new(1,0,0,38); ESP_UI_Row.BackgroundColor3=Color3.fromRGB(0,0,0); ESP_UI_Row.BackgroundTransparency=0.38; ESP_UI_Row.BorderSizePixel=0; ESP_UI_Row.LayoutOrder=7; ESP_UI_Row.ClipsDescendants=true; guiCorner(ESP_UI_Row,10); ESP_UI_Stroke=guiStroke(ESP_UI_Row,Color3.fromRGB(70,130,150),1); ESP_UI_Stroke.Transparency=0.58
    ESP_UI_Label=Instance.new("TextLabel",ESP_UI_Row); ESP_UI_Label.Size=UDim2.new(0.52,0,0,16); ESP_UI_Label.Position=UDim2.new(0,12,0,6); ESP_UI_Label.BackgroundTransparency=1; ESP_UI_Label.Text="ESP"; ESP_UI_Label.TextColor3=C.text; ESP_UI_Label.TextSize=11; ESP_UI_Label.Font=Enum.Font.GothamBold; ESP_UI_Label.TextXAlignment=Enum.TextXAlignment.Left
    ESP_UI_Arrow=Instance.new("TextButton",ESP_UI_Row); ESP_UI_Arrow.Size=UDim2.new(0,30,0,30); ESP_UI_Arrow.Position=UDim2.new(1,-92,0,4); ESP_UI_Arrow.BackgroundColor3=C.blueDark; ESP_UI_Arrow.BackgroundTransparency=0.35; ESP_UI_Arrow.BorderSizePixel=0; ESP_UI_Arrow.Text="▼"; ESP_UI_Arrow.TextColor3=C.text; ESP_UI_Arrow.TextSize=12; ESP_UI_Arrow.Font=Enum.Font.GothamBold; ESP_UI_Arrow.AutoButtonColor=false; guiCorner(ESP_UI_Arrow,8)
    ESP_UI_Track=Instance.new("Frame",ESP_UI_Row); ESP_UI_Track.Size=UDim2.new(0,42,0,22); ESP_UI_Track.Position=UDim2.new(1,-50,0,8); ESP_UI_Track.BackgroundColor3=C.blueDark; ESP_UI_Track.BackgroundTransparency=0.5; ESP_UI_Track.BorderSizePixel=0; guiCorner(ESP_UI_Track,10); guiStroke(ESP_UI_Track,C.blueDim,1)
    ESP_UI_Knob=Instance.new("Frame",ESP_UI_Track); ESP_UI_Knob.Size=UDim2.new(0,18,0,18); ESP_UI_Knob.BorderSizePixel=0; guiCorner(ESP_UI_Knob,99)
    ESP_UI_Options=Instance.new("Frame",ESP_UI_Row); ESP_UI_Options.Size=UDim2.new(1,-20,0,68); ESP_UI_Options.Position=UDim2.new(0,10,0,43); ESP_UI_Options.BackgroundTransparency=1
    local function espOption(text,y,isOn,setOn)
        local item=Instance.new("Frame",ESP_UI_Options); item.Size=UDim2.new(1,0,0,30); item.Position=UDim2.new(0,0,0,y); item.BackgroundColor3=Color3.fromRGB(22,25,30); item.BackgroundTransparency=0.35; item.BorderSizePixel=0; guiCorner(item,7)
        local title=Instance.new("TextLabel",item); title.Size=UDim2.new(0.7,0,1,0); title.Position=UDim2.new(0,10,0,0); title.BackgroundTransparency=1; title.Text=text; title.TextSize=9; title.Font=Enum.Font.GothamBold; title.TextColor3=C.text; title.TextXAlignment=Enum.TextXAlignment.Left
        local track=Instance.new("Frame",item); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-50,0.5,-11); track.BackgroundColor3=C.blueDark; track.BackgroundTransparency=0.5; track.BorderSizePixel=0; guiCorner(track,11); guiStroke(track,C.blueDim,1)
        local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,18,0,18); knob.BorderSizePixel=0; guiCorner(knob,99)
        local hit=Instance.new("TextButton",track); hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.AutoButtonColor=false
        local function paint()
            local on=isOn(); track.BackgroundColor3=on and C.blueDim or C.blueDark; knob.Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); knob.BackgroundColor3=C.blue; knob.BackgroundTransparency=on and 0.1 or 0.5
        end
        hit.MouseButton1Click:Connect(function() setOn(not isOn()); paint(); saveConfig() end)
        paint()
    end
    espOption("Box ESP",0,function() return espBoxEnabled end,function(on) espBoxEnabled=on; refreshSnowExtraESP() end)
    espOption("Line ESP",38,function() return espLineEnabled end,function(on) espLineEnabled=on; refreshSnowExtraESP() end)
    ESP_UI_Expanded=false
    local function refreshESPRow()
        ESP_UI_Track.BackgroundColor3=espEnabled and C.blueDim or C.blueDark; ESP_UI_Knob.Position=espEnabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); ESP_UI_Knob.BackgroundColor3=C.blue; ESP_UI_Knob.BackgroundTransparency=espEnabled and 0.15 or 0.5; ESP_UI_Arrow.Text=ESP_UI_Expanded and "▲" or "▼"
    end
    ESP_UI_Arrow.MouseButton1Click:Connect(function() ESP_UI_Expanded=not ESP_UI_Expanded; ESP_UI_Row.Size=UDim2.new(1,0,0,ESP_UI_Expanded and 119 or 38); refreshESPRow() end)
    ESP_UI_Hit=Instance.new("TextButton",ESP_UI_Track); ESP_UI_Hit.Size=UDim2.new(1,0,1,0); ESP_UI_Hit.BackgroundTransparency=1; ESP_UI_Hit.Text=""; ESP_UI_Hit.AutoButtonColor=false
    ESP_UI_Hit.MouseButton1Click:Connect(function()
        if espEnabled then stopESP() else startESP() end
        refreshSnowExtraESP()
        refreshESPRow(); saveConfig()
    end)
    refreshESPRow()
    addToggleRow(vi,"Anti Lag",antiLagEnabled,8,nil,function(on)
        if on then enableAntiLag() else disableAntiLag() end; saveConfig()
    end)
    addToggleRow(vi,"Colorful Graphics",colorfulGraphicsEnabled,8.1,nil,function(on)
        colorfulGraphicsEnabled=on==true
        local lighting=game:GetService("Lighting")
        if colorfulGraphicsEnabled then
            if snowColorfulEffect then snowColorfulEffect:Destroy() end
            snowColorfulEffect=Instance.new("ColorCorrectionEffect"); snowColorfulEffect.Name="SnowColorfulGraphics"; snowColorfulEffect.Saturation=.32; snowColorfulEffect.Contrast=.12; snowColorfulEffect.TintColor=Color3.fromRGB(190,225,255); snowColorfulEffect.Parent=lighting
        elseif snowColorfulEffect then snowColorfulEffect:Destroy(); snowColorfulEffect=nil end
        saveConfig()
    end)
    addToggleRow(vi,"Script Optimizer",fpsBoostEnabled,9,nil,function(on)
        if on then enableFPSBoost() else disableFPSBoost() end; saveConfig()
    end)
    -- FPS CAP — one expandable card: toggle, active value and choices.
    local fpsCapRow=Instance.new("Frame",vi); fpsCapRow.Name="FpsCapSelector"; fpsCapRow.Size=UDim2.new(1,0,0,42); fpsCapRow.BackgroundColor3=C.row; fpsCapRow.BackgroundTransparency=.5; fpsCapRow.BorderSizePixel=0; fpsCapRow.LayoutOrder=9.5; fpsCapRow.ClipsDescendants=true
    guiCorner(fpsCapRow,10); guiStroke(fpsCapRow,C.divider,1)
    local fpsCapTitle=Instance.new("TextLabel",fpsCapRow); fpsCapTitle.Position=UDim2.new(0,12,0,0); fpsCapTitle.Size=UDim2.new(0.48,0,0,42); fpsCapTitle.BackgroundTransparency=1; fpsCapTitle.Text="FPS CAP"; fpsCapTitle.TextColor3=C.text; fpsCapTitle.TextSize=11; fpsCapTitle.Font=Enum.Font.GothamBold; fpsCapTitle.TextXAlignment=Enum.TextXAlignment.Left
    local fpsCapValueLabel=Instance.new("TextLabel",fpsCapRow); fpsCapValueLabel.Position=UDim2.new(1,-164,0,0); fpsCapValueLabel.Size=UDim2.new(0,58,0,42); fpsCapValueLabel.BackgroundTransparency=1; fpsCapValueLabel.TextColor3=C.white; fpsCapValueLabel.TextSize=10; fpsCapValueLabel.Font=Enum.Font.GothamBold; fpsCapValueLabel.TextXAlignment=Enum.TextXAlignment.Right
    -- These controls must stay in the 42px header when the selector expands.
    -- Using a 0.5 Y scale made them move down with the expanded card on mobile.
    local fpsCapTrack=Instance.new("Frame",fpsCapRow); fpsCapTrack.Position=UDim2.new(1,-98,0,10); fpsCapTrack.Size=UDim2.new(0,42,0,22); fpsCapTrack.BorderSizePixel=0; guiCorner(fpsCapTrack,10); guiStroke(fpsCapTrack,C.blueDim,1)
    local fpsCapKnob=Instance.new("Frame",fpsCapTrack); fpsCapKnob.Size=UDim2.new(0,18,0,18); fpsCapKnob.BorderSizePixel=0; guiCorner(fpsCapKnob,99)
    local fpsCapToggle=Instance.new("TextButton",fpsCapTrack); fpsCapToggle.Size=UDim2.new(1,0,1,0); fpsCapToggle.BackgroundTransparency=1; fpsCapToggle.Text=""
    local fpsCapArrow=Instance.new("TextButton",fpsCapRow); fpsCapArrow.Position=UDim2.new(1,-40,0,8); fpsCapArrow.Size=UDim2.new(0,27,0,26); fpsCapArrow.BackgroundColor3=Color3.fromRGB(8,10,13); fpsCapArrow.BorderSizePixel=0; fpsCapArrow.AutoButtonColor=false; fpsCapArrow.Text="▼"; fpsCapArrow.TextColor3=C.white; fpsCapArrow.TextSize=10; fpsCapArrow.Font=Enum.Font.GothamBold; fpsCapArrow.ZIndex=2; guiCorner(fpsCapArrow,7); guiStroke(fpsCapArrow,Color3.fromRGB(95,105,115),1)
    local fpsChoices=Instance.new("Frame",fpsCapRow); fpsChoices.Position=UDim2.new(0,10,0,49); fpsChoices.Size=UDim2.new(1,-20,0,30); fpsChoices.BackgroundTransparency=1; fpsChoices.Visible=false
    local fpsOpen=false
    local function refreshFpsCap()
        fpsCapValueLabel.Text=fpsCapEnabled and (tostring(fpsCapValue).." FPS") or "OFF"
        -- Keep the active value visible in the top-right even while expanded.
        fpsCapValueLabel.Visible=true
        fpsCapTrack.BackgroundColor3=fpsCapEnabled and C.blueDim or C.blueDark
        fpsCapKnob.Position=fpsCapEnabled and UDim2.new(1,-20,.5,-9) or UDim2.new(0,2,.5,-9)
        fpsCapKnob.BackgroundColor3=C.blue
        fpsCapKnob.BackgroundTransparency=fpsCapEnabled and .15 or .5
        fpsCapArrow.Text=fpsOpen and "▲" or "▼"
        fpsChoices.Visible=fpsOpen
        fpsCapRow.Size=UDim2.new(1,0,0,fpsOpen and 127 or 42)
    end
    local function setFpsCap(value)
        fpsCapValue=math.clamp(math.floor(tonumber(value) or 60),60,1000)
        if fpsCapEnabled and DragonApplyFpsCap then DragonApplyFpsCap() end
        fpsOpen=false; refreshFpsCap(); saveConfig()
    end
    fpsCapToggle.MouseButton1Click:Connect(function()
        fpsCapEnabled=not fpsCapEnabled
        if DragonApplyFpsCap then DragonApplyFpsCap() end
        refreshFpsCap(); saveConfig()
    end)
    for index,value in ipairs({60,120,240,360}) do
        local choice=Instance.new("TextButton",fpsChoices); choice.Position=UDim2.new((index-1)*.25,2,0,0); choice.Size=UDim2.new(.25,-4,1,0); choice.BackgroundColor3=Color3.fromRGB(22,25,30); choice.BorderSizePixel=0; choice.AutoButtonColor=false; choice.Text=tostring(value); choice.TextColor3=C.white; choice.TextSize=10; choice.Font=Enum.Font.GothamBold; guiCorner(choice,7)
        choice.MouseButton1Click:Connect(function() setFpsCap(value) end)
    end
    local customBox=Instance.new("TextBox",fpsCapRow); customBox.Position=UDim2.new(0,10,0,88); customBox.Size=UDim2.new(1,-94,0,29); customBox.BackgroundColor3=Color3.fromRGB(10,12,16); customBox.BorderSizePixel=0; customBox.ClearTextOnFocus=false; customBox.PlaceholderText=""; customBox.PlaceholderColor3=Color3.fromRGB(255,255,255); customBox.Text=""; customBox.TextColor3=Color3.fromRGB(255,255,255); customBox.TextSize=10; customBox.Font=Enum.Font.GothamBold; guiCorner(customBox,7); guiStroke(customBox,C.divider,1)
    local customSet=Instance.new("TextButton",fpsCapRow); customSet.Position=UDim2.new(1,-76,0,88); customSet.Size=UDim2.new(0,66,0,29); customSet.BackgroundColor3=C.blueDark; customSet.BorderSizePixel=0; customSet.AutoButtonColor=false; customSet.Text="SET"; customSet.TextColor3=C.white; customSet.TextSize=10; customSet.Font=Enum.Font.GothamBold; guiCorner(customSet,7); guiStroke(customSet,C.blueDim,1)
    fpsCapArrow.MouseButton1Click:Connect(function() fpsOpen=not fpsOpen; refreshFpsCap() end)
    customSet.MouseButton1Click:Connect(function() setFpsCap(customBox.Text) end)
    customBox.FocusLost:Connect(function(enterPressed) if enterPressed then setFpsCap(customBox.Text) end end)
    refreshFpsCap()
    addSectLbl(vi,"FOV",11)
    addToggleRow(vi,"Stretch Rez",stretchRezEnabled,13,nil,function(on)
        if on then enableStretchRez() else disableStretchRez() end; saveConfig()
    end)
    local stretchRow=Instance.new("Frame",vi); stretchRow.Size=UDim2.new(1,0,0,66); stretchRow.BackgroundColor3=C.row; stretchRow.BackgroundTransparency=.5; stretchRow.BorderSizePixel=0; stretchRow.LayoutOrder=13.05; guiCorner(stretchRow,10); guiStroke(stretchRow,C.divider,1)
    local stretchLabel=Instance.new("TextLabel",stretchRow); stretchLabel.Size=UDim2.new(1,-24,0,16); stretchLabel.Position=UDim2.new(0,12,0,6); stretchLabel.BackgroundTransparency=1; stretchLabel.Text="STRETCH REZ VALUE"; stretchLabel.TextColor3=C.text; stretchLabel.TextSize=11; stretchLabel.Font=Enum.Font.GothamBold; stretchLabel.TextXAlignment=Enum.TextXAlignment.Left
    local stretchValue=Instance.new("TextLabel",stretchRow); stretchValue.Size=UDim2.new(1,-96,0,26); stretchValue.Position=UDim2.new(0,48,0,32); stretchValue.BackgroundTransparency=1; stretchValue.TextColor3=C.white; stretchValue.TextSize=11; stretchValue.Font=Enum.Font.GothamBold; stretchValue.TextXAlignment=Enum.TextXAlignment.Center
    local stretchLeft=Instance.new("TextButton",stretchRow); stretchLeft.Size=UDim2.new(0,30,0,26); stretchLeft.Position=UDim2.new(0,12,0,31); stretchLeft.BackgroundColor3=C.blueDark; stretchLeft.BorderSizePixel=0; stretchLeft.Text="‹"; stretchLeft.TextColor3=C.white; stretchLeft.TextSize=18; guiCorner(stretchLeft,7)
    local stretchRight=Instance.new("TextButton",stretchRow); stretchRight.Size=UDim2.new(0,30,0,26); stretchRight.Position=UDim2.new(1,-42,0,31); stretchRight.BackgroundColor3=C.blueDark; stretchRight.BorderSizePixel=0; stretchRight.Text="›"; stretchRight.TextColor3=C.white; stretchRight.TextSize=18; guiCorner(stretchRight,7)
    local stretchChoices={2,3,4}; local stretchIndex=table.find(stretchChoices,stretchRezScale) or 1
    local function setStretch(index) stretchIndex=(index-1)%#stretchChoices+1; stretchRezScale=stretchChoices[stretchIndex]; stretchValue.Text="X"..stretchRezScale; saveConfig() end
    setStretch(stretchIndex); stretchLeft.MouseButton1Click:Connect(function() setStretch(stretchIndex-1) end); stretchRight.MouseButton1Click:Connect(function() setStretch(stretchIndex+1) end)
    addToggleRow(vi,"Motion Blur",motionBlurEnabled,13.1,nil,function(on)
        motionBlurEnabled=on==true
        local lighting=game:GetService("Lighting")
        if motionBlurEnabled then
            if snowMotionBlur then snowMotionBlur:Destroy() end
            snowMotionBlur=Instance.new("BlurEffect"); snowMotionBlur.Name="SnowMotionBlur"; snowMotionBlur.Size=7; snowMotionBlur.Parent=lighting
        elseif snowMotionBlur then snowMotionBlur:Destroy(); snowMotionBlur=nil end
        saveConfig()
    end)
    addSectLbl(vi,"ALERT",14)
    addToggleRow(vi,"Ragdoll Alert",ragdollGuiEnabled,15,nil,function(on) ragdollGuiEnabled=on; saveConfig() end)
    addToggleRow(vi,"Enemy Ragdoll Alert",Dragon.enemyRagdollTimerEnabled,15.1,nil,function(on)
        Dragon.enemyRagdollTimerEnabled=on==true
        if Dragon.enemyRagdollTimerEnabled then Dragon.startEnemyRagdollTimer() else Dragon.stopEnemyRagdollTimer() end
        saveConfig()
    end)
    local e01Row=addToggleRow(vi,"E01 Alert",e01AlertEnabled,16,nil,function(on) e01AlertEnabled=on==true; saveConfig() end)
    local e01Arrow=Instance.new("TextButton",e01Row); e01Arrow.Size=UDim2.new(0,30,0,30); e01Arrow.Position=UDim2.new(1,-92,0,8); e01Arrow.BackgroundTransparency=1; e01Arrow.BorderSizePixel=0; e01Arrow.Text="▼"; e01Arrow.TextColor3=C.text; e01Arrow.TextSize=14; e01Arrow.Font=Enum.Font.GothamBold; e01Arrow.AutoButtonColor=false
    local e01SizeRow=Instance.new("Frame",vi); e01SizeRow.Size=UDim2.new(1,0,0,38); e01SizeRow.LayoutOrder=16.05; e01SizeRow.BackgroundColor3=Color3.fromRGB(0,0,0); e01SizeRow.BackgroundTransparency=.38; e01SizeRow.BorderSizePixel=0; e01SizeRow.Visible=false; guiCorner(e01SizeRow,10); guiStroke(e01SizeRow,Color3.fromRGB(70,130,150),1).Transparency=.58
    local e01SizeLabel=Instance.new("TextLabel",e01SizeRow); e01SizeLabel.Size=UDim2.new(.55,0,1,0); e01SizeLabel.Position=UDim2.new(0,12,0,0); e01SizeLabel.BackgroundTransparency=1; e01SizeLabel.Text="ALERT SIZE"; e01SizeLabel.TextColor3=C.text; e01SizeLabel.TextSize=10; e01SizeLabel.Font=Enum.Font.GothamBold; e01SizeLabel.TextXAlignment=Enum.TextXAlignment.Left
    local e01Minus=Instance.new("TextButton",e01SizeRow); e01Minus.Size=UDim2.new(0,28,0,26); e01Minus.Position=UDim2.new(1,-116,.5,-13); e01Minus.BackgroundTransparency=1; e01Minus.BorderSizePixel=0; e01Minus.Text="−"; e01Minus.TextColor3=C.white; e01Minus.TextSize=18; e01Minus.Font=Enum.Font.GothamBold; e01Minus.AutoButtonColor=false
    local e01SizeValue=Instance.new("TextLabel",e01SizeRow); e01SizeValue.Size=UDim2.new(0,54,0,24); e01SizeValue.Position=UDim2.new(1,-84,.5,-12); e01SizeValue.BackgroundTransparency=1; e01SizeValue.TextColor3=C.white; e01SizeValue.TextSize=10; e01SizeValue.Font=Enum.Font.GothamBold; e01SizeValue.TextXAlignment=Enum.TextXAlignment.Center
    local e01Plus=Instance.new("TextButton",e01SizeRow); e01Plus.Size=UDim2.new(0,28,0,26); e01Plus.Position=UDim2.new(1,-32,.5,-13); e01Plus.BackgroundTransparency=1; e01Plus.BorderSizePixel=0; e01Plus.Text="+"; e01Plus.TextColor3=C.white; e01Plus.TextSize=18; e01Plus.Font=Enum.Font.GothamBold; e01Plus.AutoButtonColor=false
    local function setE01Size(value)
        e01AlertScale=math.clamp(math.floor(value*100+.5)/100,.7,1.4)
        e01SizeValue.Text=tostring(math.floor(e01AlertScale*100+.5)).."%"
        if Dragon.previewE01Alert then Dragon.previewE01Alert(2) end
        saveConfig()
    end
    setE01Size(e01AlertScale)
    e01Minus.MouseButton1Click:Connect(function() setE01Size(e01AlertScale-.05) end)
    e01Plus.MouseButton1Click:Connect(function() setE01Size(e01AlertScale+.05) end)
    e01Arrow.MouseButton1Click:Connect(function() e01SizeRow.Visible=not e01SizeRow.Visible; e01Arrow.Text=e01SizeRow.Visible and "▲" or "▼" end)
    addToggleRow(vi,"Show Ping Warner",not hidePingWarner,17,nil,function(on)
        hidePingWarner=not (on==true)
        if hidePingWarner then
            -- Hide both warning styles immediately; their update loops also
            -- honor hidePingWarner so they cannot return on the next tick.
            for _,root in ipairs({game:GetService("CoreGui"),LP:FindFirstChild("PlayerGui")}) do
                local gui=root and root:FindFirstChild("SnowStealBar")
                if gui then
                    for _,name in ipairs({"PingBanner","PingWarner"}) do
                        local warning=gui:FindFirstChild(name,true)
                        if warning then warning.Visible=false; warning.Active=false end
                    end
                end
            end
        end
        saveConfig()
    end)
    addToggleRow(vi,"Enemy Speed",enemySpeedEnabled,18,nil,function(on)
        if on then startEnemySpeedESP() else stopEnemySpeedESP() end
        saveConfig()
    end)
    addSectLbl(vi,"ANIMATION PACK",20)
    local animIdx=1
    for i,n in ipairs(ANIM_PACK_ORDER) do if n==animPackName then animIdx=i; break end end
    local animRow=Instance.new("Frame"); animRow.Size=UDim2.new(1,0,0,66); animRow.BackgroundColor3=C.row
    animRow.BackgroundTransparency=0.5; animRow.BorderSizePixel=0; animRow.LayoutOrder=21; animRow.Parent=vi
    guiCorner(animRow,10); guiStroke(animRow,C.divider,1)
    local animLbl=Instance.new("TextLabel",animRow); animLbl.Size=UDim2.new(1,-24,0,16); animLbl.Position=UDim2.new(0,12,0,6)
    animLbl.BackgroundTransparency=1; animLbl.Text="Anim Pack"; animLbl.TextColor3=C.text; animLbl.TextSize=11; animLbl.Font=Enum.Font.GothamBold; animLbl.TextXAlignment=Enum.TextXAlignment.Left
    local animVal=Instance.new("TextLabel",animRow); animVal.Size=UDim2.new(1,-96,0,26); animVal.Position=UDim2.new(0,48,0,32)
    animVal.BackgroundTransparency=1; animVal.BorderSizePixel=0; animVal.Text=animPackName; animVal.TextColor3=C.white; animVal.TextSize=10; animVal.Font=Enum.Font.GothamBold; animVal.TextXAlignment=Enum.TextXAlignment.Center
    local animPrev=Instance.new("TextButton",animRow); animPrev.Size=UDim2.new(0,30,0,26); animPrev.Position=UDim2.new(0,12,0,31)
    animPrev.BackgroundColor3=Color3.fromRGB(8,10,13); animPrev.BackgroundTransparency=0.15; animPrev.BorderSizePixel=0; animPrev.Text="‹"
    animPrev.TextColor3=C.white; animPrev.TextSize=18; animPrev.Font=Enum.Font.GothamBold; guiCorner(animPrev,7); guiStroke(animPrev,Color3.fromRGB(95,105,115),1)
    local animBtn=Instance.new("TextButton",animRow); animBtn.Size=UDim2.new(0,30,0,26); animBtn.Position=UDim2.new(1,-42,0,31)
    animBtn.BackgroundColor3=Color3.fromRGB(8,10,13); animBtn.BackgroundTransparency=0.15; animBtn.BorderSizePixel=0; animBtn.Text="›"
    animBtn.TextColor3=C.white; animBtn.TextSize=18; animBtn.Font=Enum.Font.GothamBold; guiCorner(animBtn,7); guiStroke(animBtn,Color3.fromRGB(95,105,115),1)
    local function setAnimIndex(index)
        animIdx=(index-1)%#ANIM_PACK_ORDER+1
        animPackName=ANIM_PACK_ORDER[animIdx]
        animVal.Text=animPackName
        animPackEnabled=(animPackName~="OFF")
        applyAnimPack(animPackName)
        saveConfig()
    end
    animPrev.MouseButton1Click:Connect(function() setAnimIndex(animIdx-1) end)
    animBtn.MouseButton1Click:Connect(function() setAnimIndex(animIdx+1) end)
    addSectLbl(vi,"SKY THEME",18)
    local skyIdx=1; for i,t in ipairs(SnowSkyOrder) do if t==SnowCurrentSkyTheme then skyIdx=i; break end end
    local skyRow=Instance.new("Frame"); skyRow.Size=UDim2.new(1,0,0,66); skyRow.BackgroundColor3=C.row
    skyRow.BackgroundTransparency=0.5; skyRow.BorderSizePixel=0; skyRow.LayoutOrder=19; skyRow.Parent=vi
    guiCorner(skyRow,10); guiStroke(skyRow,C.divider,1)
    local skyLbl=Instance.new("TextLabel",skyRow); skyLbl.Size=UDim2.new(1,-24,0,16); skyLbl.Position=UDim2.new(0,12,0,6)
    skyLbl.BackgroundTransparency=1; skyLbl.Text="Sky Theme"; skyLbl.TextColor3=C.text; skyLbl.TextSize=11; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextXAlignment=Enum.TextXAlignment.Left
    local skyVal=Instance.new("TextLabel",skyRow); skyVal.Size=UDim2.new(1,-96,0,26); skyVal.Position=UDim2.new(0,48,0,32)
    skyVal.BackgroundTransparency=1; skyVal.BorderSizePixel=0; skyVal.Text=SnowCurrentSkyTheme; skyVal.TextColor3=C.white; skyVal.TextSize=10; skyVal.Font=Enum.Font.GothamBold; skyVal.TextXAlignment=Enum.TextXAlignment.Center
    local skyPrev=Instance.new("TextButton",skyRow); skyPrev.Size=UDim2.new(0,30,0,26); skyPrev.Position=UDim2.new(0,12,0,31)
    skyPrev.BackgroundColor3=Color3.fromRGB(8,10,13); skyPrev.BackgroundTransparency=0.15; skyPrev.BorderSizePixel=0; skyPrev.Text="‹"
    skyPrev.TextColor3=C.white; skyPrev.TextSize=18; skyPrev.Font=Enum.Font.GothamBold; guiCorner(skyPrev,7); guiStroke(skyPrev,Color3.fromRGB(95,105,115),1)
    local skyBtn=Instance.new("TextButton",skyRow); skyBtn.Size=UDim2.new(0,30,0,26); skyBtn.Position=UDim2.new(1,-42,0,31)
    skyBtn.BackgroundColor3=Color3.fromRGB(8,10,13); skyBtn.BackgroundTransparency=0.15; skyBtn.BorderSizePixel=0; skyBtn.Text="›"
    skyBtn.TextColor3=C.white; skyBtn.TextSize=18; skyBtn.Font=Enum.Font.GothamBold; guiCorner(skyBtn,7); guiStroke(skyBtn,Color3.fromRGB(95,105,115),1)
    local function setSkyIndex(index)
        skyIdx=(index-1)%#SnowSkyOrder+1; SnowCurrentSkyTheme=SnowSkyOrder[skyIdx]; skyVal.Text=SnowCurrentSkyTheme
        SnowApplySkyTheme(SnowCurrentSkyTheme); saveConfig()
    end
    skyPrev.MouseButton1Click:Connect(function() setSkyIndex(skyIdx-1) end)
    skyBtn.MouseButton1Click:Connect(function() setSkyIndex(skyIdx+1) end)
    local hov2=Instance.new("TextButton",skyRow); hov2.Size=UDim2.new(1,0,1,0); hov2.BackgroundTransparency=1; hov2.Text=""; hov2.ZIndex=0
    hov2.MouseEnter:Connect(function() tw(skyRow,{BackgroundTransparency=0.3}) end)
    hov2.MouseLeave:Connect(function() tw(skyRow,{BackgroundTransparency=0.5}) end)
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,66); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.5; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=12; fovRow.Parent=vi
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(1,-24,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=C.text; fovLbl.TextSize=11; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovPrev=Instance.new("TextButton",fovRow); fovPrev.Size=UDim2.new(0,30,0,26); fovPrev.Position=UDim2.new(0,12,0,31)
    fovPrev.BackgroundColor3=Color3.fromRGB(8,10,13); fovPrev.BackgroundTransparency=0.15; fovPrev.BorderSizePixel=0; fovPrev.Text="‹"; fovPrev.TextColor3=C.white; fovPrev.TextSize=18; fovPrev.Font=Enum.Font.GothamBold; guiCorner(fovPrev,7); guiStroke(fovPrev,Color3.fromRGB(95,105,115),1)
    local fovBtn=Instance.new("TextLabel",fovRow); fovBtn.Size=UDim2.new(1,-96,0,26); fovBtn.Position=UDim2.new(0,48,0,32)
    fovBtn.BackgroundTransparency=1; fovBtn.BorderSizePixel=0; fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=C.white; fovBtn.TextSize=11; fovBtn.Font=Enum.Font.GothamBold; fovBtn.TextXAlignment=Enum.TextXAlignment.Center
    local fovNext=Instance.new("TextButton",fovRow); fovNext.Size=UDim2.new(0,30,0,26); fovNext.Position=UDim2.new(1,-42,0,31)
    fovNext.BackgroundColor3=Color3.fromRGB(8,10,13); fovNext.BackgroundTransparency=0.15; fovNext.BorderSizePixel=0; fovNext.Text="›"; fovNext.TextColor3=C.white; fovNext.TextSize=18; fovNext.Font=Enum.Font.GothamBold; guiCorner(fovNext,7); guiStroke(fovNext,Color3.fromRGB(95,105,115),1)
    local function setFovIndex(index)
        fovIndex=(index-1)%#fovOptions+1; fovValue=fovOptions[fovIndex]; fovBtn.Text=tostring(fovValue); applyFOV(); saveConfig()
    end
    fovPrev.MouseButton1Click:Connect(function() setFovIndex(fovIndex-1) end)
    fovNext.MouseButton1Click:Connect(function() setFovIndex(fovIndex+1) end)
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.3}) end)
    hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.5}) end)
    addSectLbl(settings,"UI SETTINGS",3)
    addToggleRow(settings,"UI Auto Fade",uiAutoFadeEnabled,3.1,nil,function(on)
        uiAutoFadeEnabled=on==true
        if not uiAutoFadeEnabled and GuiRefs.chromeGroup then GuiRefs.chromeGroup.GroupTransparency=0 end
        saveConfig()
    end)
    local tabPosRow=Instance.new("Frame",settings); tabPosRow.Name="TabsPositionSelector"; tabPosRow.Size=UDim2.new(1,0,0,66); tabPosRow.BackgroundColor3=C.row; tabPosRow.BackgroundTransparency=.5; tabPosRow.BorderSizePixel=0; tabPosRow.LayoutOrder=4.1
    guiCorner(tabPosRow,10); guiStroke(tabPosRow,C.divider,1)
    local tabPosLabel=Instance.new("TextLabel",tabPosRow); tabPosLabel.Size=UDim2.new(1,-24,0,16); tabPosLabel.Position=UDim2.new(0,12,0,6); tabPosLabel.BackgroundTransparency=1; tabPosLabel.Text="TABS POSITION SELECTOR"; tabPosLabel.TextColor3=C.text; tabPosLabel.TextSize=11; tabPosLabel.Font=Enum.Font.GothamBold; tabPosLabel.TextXAlignment=Enum.TextXAlignment.Left
    local tabTop=Instance.new("TextButton",tabPosRow); tabTop.Size=UDim2.new(.5,-16,0,26); tabTop.Position=UDim2.new(0,12,0,31); tabTop.BorderSizePixel=0; tabTop.Text="TOP"; tabTop.TextSize=10; tabTop.Font=Enum.Font.GothamBold; tabTop.AutoButtonColor=false; guiCorner(tabTop,7)
    local tabBottom=Instance.new("TextButton",tabPosRow); tabBottom.Size=UDim2.new(.5,-16,0,26); tabBottom.Position=UDim2.new(.5,4,0,31); tabBottom.BorderSizePixel=0; tabBottom.Text="BOTTOM"; tabBottom.TextSize=10; tabBottom.Font=Enum.Font.GothamBold; tabBottom.AutoButtonColor=false; guiCorner(tabBottom,7)
    local function applyTabsPosition()
        local inner=GuiRefs.inner; local tab=GuiRefs.categoryList and GuiRefs.categoryList.Parent; local content=GuiRefs.contentFrame
        if not inner or not tab or not content then return end
        if tabsPosition=="BOTTOM" then
            tab.Position=UDim2.new(0,2,1,-44); content.Position=UDim2.new(0,8,0,96); content.Size=UDim2.new(1,-16,1,-144)
        else
            tab.Position=UDim2.new(0,2,0,88); content.Position=UDim2.new(0,8,0,134); content.Size=UDim2.new(1,-16,1,-136)
        end
    end
    local function setTabsPosition(position)
        tabsPosition=position
        local top=(tabsPosition=="TOP")
        tabTop.BackgroundColor3=top and C.blueDim or Color3.fromRGB(22,25,30); tabTop.BackgroundTransparency=top and .1 or .35; tabTop.TextColor3=top and C.white or C.textDim
        tabBottom.BackgroundColor3=not top and C.blueDim or Color3.fromRGB(22,25,30); tabBottom.BackgroundTransparency=not top and .1 or .35; tabBottom.TextColor3=not top and C.white or C.textDim
        applyTabsPosition(); saveConfig()
    end
    setTabsPosition(tabsPosition); tabTop.MouseButton1Click:Connect(function() setTabsPosition("TOP") end); tabBottom.MouseButton1Click:Connect(function() setTabsPosition("BOTTOM") end)
    task.defer(function() setTabsPosition(tabsPosition) end)
    local dockRow=Instance.new("Frame",settings); dockRow.Name="CollapsedTabSelector"; dockRow.Size=UDim2.new(1,0,0,66); dockRow.BackgroundColor3=C.row; dockRow.BackgroundTransparency=.5; dockRow.BorderSizePixel=0; dockRow.LayoutOrder=4.2
    guiCorner(dockRow,10); guiStroke(dockRow,C.divider,1)
    local dockLabel=Instance.new("TextLabel",dockRow); dockLabel.Size=UDim2.new(1,-24,0,16); dockLabel.Position=UDim2.new(0,12,0,6); dockLabel.BackgroundTransparency=1; dockLabel.Text="COLLAPSED TAB POSITION"; dockLabel.TextColor3=C.text; dockLabel.TextSize=11; dockLabel.Font=Enum.Font.GothamBold; dockLabel.TextXAlignment=Enum.TextXAlignment.Left
    local dockButtons={}
    for i,name in ipairs({"LEFT","RIGHT","FREE"}) do
        local button=Instance.new("TextButton",dockRow); button.Size=UDim2.new(1/3,-16,0,26); button.Position=UDim2.new((i-1)/3,12-(i-1)*4,0,31); button.BorderSizePixel=0; button.Text=name; button.TextSize=9; button.Font=Enum.Font.GothamBold; button.AutoButtonColor=false; guiCorner(button,7)
        dockButtons[name]=button
    end
    local function refreshCollapsedTabPosition()
        for name,button in pairs(dockButtons) do
            local on=name==collapsedTabMode
            button.BackgroundColor3=on and C.blueDim or Color3.fromRGB(22,25,30); button.BackgroundTransparency=on and .1 or .35; button.TextColor3=on and C.white or C.textDim
        end
    end
    local function setCollapsedTabPosition(mode)
        if mode~="LEFT" and mode~="RIGHT" and mode~="FREE" then mode="RIGHT" end
        collapsedTabMode=mode
        refreshCollapsedTabPosition()
        if GuiRefs.applyCollapsedTabMode then GuiRefs.applyCollapsedTabMode(mode,false) end
        saveConfig()
    end
    GuiRefs.refreshCollapsedTabPosition=refreshCollapsedTabPosition
    setCollapsedTabPosition(collapsedTabMode)
    task.defer(refreshCollapsedTabPosition)
    for name,button in pairs(dockButtons) do
        local selectedMode=name
        button.MouseButton1Click:Connect(function() setCollapsedTabPosition(selectedMode) end)
    end
    local function makePlusMinusRow(parent,label,order,getVal,setVal,fmt,step,minV,maxV)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,66); row.BackgroundColor3=C.row
        row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=order; row.Parent=parent
        guiCorner(row,10); guiStroke(row,C.divider,1)
        local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,-24,0,16); lbl.Position=UDim2.new(0,12,0,6)
        lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text; lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local minusBtn=Instance.new("TextButton",row); minusBtn.Size=UDim2.new(0,30,0,26); minusBtn.Position=UDim2.new(0,12,0,31)
        minusBtn.BackgroundColor3=Color3.fromRGB(10,12,15); minusBtn.BackgroundTransparency=0.15; minusBtn.BorderSizePixel=0
        minusBtn.Text="−"; minusBtn.TextColor3=C.white; minusBtn.TextSize=17; minusBtn.Font=Enum.Font.GothamBold; guiCorner(minusBtn,7); guiStroke(minusBtn,Color3.fromRGB(95,105,115),1)
        local valLbl=Instance.new("TextLabel",row); valLbl.Size=UDim2.new(1,-96,0,26); valLbl.Position=UDim2.new(0,48,0,32)
        valLbl.BackgroundTransparency=1; valLbl.BorderSizePixel=0; valLbl.Text=fmt(getVal()); valLbl.TextColor3=C.white; valLbl.TextSize=11; valLbl.Font=Enum.Font.GothamBold; valLbl.TextXAlignment=Enum.TextXAlignment.Center
        local plusBtn=Instance.new("TextButton",row); plusBtn.Size=UDim2.new(0,30,0,26); plusBtn.Position=UDim2.new(1,-42,0,31)
        plusBtn.BackgroundColor3=Color3.fromRGB(10,12,15); plusBtn.BackgroundTransparency=0.15; plusBtn.BorderSizePixel=0
        plusBtn.Text="+"; plusBtn.TextColor3=C.white; plusBtn.TextSize=16; plusBtn.Font=Enum.Font.GothamBold; guiCorner(plusBtn,7); guiStroke(plusBtn,Color3.fromRGB(95,105,115),1)
        local function apply(delta)
            local v=math.clamp(getVal()+delta,minV,maxV)
            setVal(v)
            valLbl.Text=fmt(v)
            saveConfig()
        end
        minusBtn.MouseButton1Click:Connect(function() apply(-step) end)
        plusBtn.MouseButton1Click:Connect(function() apply(step) end)
        local hov=Instance.new("TextButton",row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function() tw(row,{BackgroundTransparency=0.3}) end)
        hov.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.5}) end)
        return valLbl
    end

    local uiScaleVal = (GuiRefs.outerScale and GuiRefs.outerScale.Scale) or 0.70
    makePlusMinusRow(settings,"UI Size",4,
        function() return uiScaleVal end,
        function(v)
            uiScaleVal=v
            if GuiRefs.outerScale then GuiRefs.outerScale.Scale=v end
        end,
        function(v) return string.format("%.2f",v) end,
        0.05, 0.50, 1.30
    )

    addSectLbl(settings,"MOBILE BUTTONS",10)
    makePlusMinusRow(settings,"Mobile Buttons Size",11,
        function() return tonumber(mobileButtonsSize) or 80 end,
        function(v)
            mobileButtonsSize=math.floor(v+0.5)
            if mobileButtonsEnabled and buildMobileButtons then
                buildMobileButtons()
            end
        end,
        function(v) return tostring(math.floor(v+0.5)) end,
        10, 50, 140
    )

    addToggleRow(settings,"Circle Mobile Buttons",circleButtonsEnabled,12,nil,function(on)
        circleButtonsEnabled=on
        if mobileButtonsEnabled and buildMobileButtons then buildMobileButtons() end
        saveConfig()
    end)
    addToggleRow(settings,"Lock Mobile Buttons",mobileButtonsLocked,13,nil,function(on)
        mobileButtonsLocked=on; saveConfig()
    end)
    -- Mobile-button visibility picker.  The arrow opens individual show/hide
    -- switches instead of hiding the entire pad at once.
    local picker=Instance.new("Frame",settings); picker.Size=UDim2.new(1,0,0,46); picker.LayoutOrder=14; picker.BackgroundColor3=Color3.fromRGB(0,0,0); picker.BackgroundTransparency=0.38; picker.BorderSizePixel=0; picker.ClipsDescendants=true; guiCorner(picker,10); guiStroke(picker,Color3.fromRGB(70,130,150),1).Transparency=0.58
    local pickerLabel=Instance.new("TextLabel",picker); pickerLabel.Size=UDim2.new(1,-108,0,46); pickerLabel.Position=UDim2.new(0,12,0,0); pickerLabel.BackgroundTransparency=1; pickerLabel.Text="Hide Mobile Buttons"; pickerLabel.TextColor3=C.text; pickerLabel.TextSize=11; pickerLabel.Font=Enum.Font.GothamBold; pickerLabel.TextXAlignment=Enum.TextXAlignment.Left
    local pickerArrow=Instance.new("TextButton",picker); pickerArrow.Size=UDim2.new(0,30,0,30); pickerArrow.Position=UDim2.new(1,-92,0,8); pickerArrow.BackgroundColor3=C.blueDark; pickerArrow.BackgroundTransparency=0.35; pickerArrow.BorderSizePixel=0; pickerArrow.Text="▼"; pickerArrow.TextColor3=C.text; pickerArrow.TextSize=12; pickerArrow.Font=Enum.Font.GothamBold; guiCorner(pickerArrow,8)
    local hideTrack=Instance.new("Frame",picker); hideTrack.Size=UDim2.new(0,42,0,22); hideTrack.Position=UDim2.new(1,-52,0.5,-11); hideTrack.BackgroundColor3=mobileButtonsEnabled and C.blueDark or C.blueDim; hideTrack.BackgroundTransparency=0.5; hideTrack.BorderSizePixel=0; guiCorner(hideTrack,11); guiStroke(hideTrack,C.blueDim,1)
    local hideKnob=Instance.new("Frame",hideTrack); hideKnob.Size=UDim2.new(0,18,0,18); hideKnob.Position=mobileButtonsEnabled and UDim2.new(0,2,0.5,-9) or UDim2.new(1,-20,0.5,-9); hideKnob.BackgroundColor3=C.blue; hideKnob.BackgroundTransparency=mobileButtonsEnabled and 0.5 or 0.15; hideKnob.BorderSizePixel=0; guiCorner(hideKnob,99)
    local hideHit=Instance.new("TextButton",hideTrack); hideHit.Size=UDim2.new(1,0,1,0); hideHit.BackgroundTransparency=1; hideHit.Text=""; hideHit.AutoButtonColor=false
    hideHit.MouseButton1Click:Connect(function()
        mobileButtonsEnabled=not mobileButtonsEnabled
        if mobileButtonsEnabled then if buildMobileButtons then buildMobileButtons() end else if destroyMobileButtons then destroyMobileButtons() end end
        hideTrack.BackgroundColor3=mobileButtonsEnabled and C.blueDark or C.blueDim
        hideKnob.Position=mobileButtonsEnabled and UDim2.new(0,2,0.5,-9) or UDim2.new(1,-20,0.5,-9)
        hideKnob.BackgroundTransparency=mobileButtonsEnabled and 0.5 or 0.15
        saveConfig()
    end)
    local pickerOpen=false
    local buttonNames={{"TP_BAT","TP BAT"},{"INSTA_RESET","INSTA RESET"},{"DROP_BR","DROP BR"},{"AUTO_LEFT","AUTO LEFT"},{"BAT_AIMBOT","BAT AIMBOT"},{"AUTO_RIGHT","AUTO RIGHT"},{"TP_DOWN","TP DOWN"},{"CARRY_SPEED","CARRY SPEED"},{"LAGGER_CARRY","LAGGER CARRY"},{"LAGGER_NORMAL","LAGGER NORMAL"}}
    for index,data in ipairs(buttonNames) do
        local key,title=data[1],data[2]
        local row=Instance.new("TextButton",picker); row.Size=UDim2.new(1,-20,0,30); row.Position=UDim2.new(0,10,0,48+(index-1)*34); row.BackgroundColor3=Color3.fromRGB(22,25,30); row.BackgroundTransparency=0.25; row.BorderSizePixel=0; row.Text=""; row.AutoButtonColor=false; guiCorner(row,7)
        local text=Instance.new("TextLabel",row); text.Size=UDim2.new(1,-60,1,0); text.Position=UDim2.new(0,10,0,0); text.BackgroundTransparency=1; text.Text=title; text.TextColor3=C.text; text.TextSize=10; text.Font=Enum.Font.GothamBold; text.TextXAlignment=Enum.TextXAlignment.Left
        local state=Instance.new("Frame",row); state.Name="VisibilityToggle"; state.Size=UDim2.new(0,34,0,18); state.Position=UDim2.new(1,-42,0.5,-9); state.BorderSizePixel=0; guiCorner(state,9)
        local dot=Instance.new("Frame",state); dot.Size=UDim2.new(0,14,0,14); dot.Position=UDim2.new(0,2,0.5,-7); dot.BorderSizePixel=0; guiCorner(dot,99)
        local function paint()
            local ref=mobileButtonFrames[key]
            local shown
            if ref and ref.frame then shown=ref.frame.Visible else shown=mobileButtonVisibility[key]~=false end
            mobileButtonVisibility[key]=shown
            state.BackgroundColor3=shown and Color3.fromRGB(70,70,76) or Color3.fromRGB(10,10,12)
            state.BackgroundTransparency=shown and .18 or .42
            dot.BackgroundColor3=shown and Color3.fromRGB(255,255,255) or Color3.fromRGB(110,110,116)
            dot.BackgroundTransparency=shown and .06 or .52
            dot.Position=shown and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
        end
        row.MouseButton1Click:Connect(function()
            local shown=mobileButtonVisibility[key]~=false
            mobileButtonVisibility[key]=not shown
            local ref=mobileButtonFrames[key]
            if ref and ref.frame then ref.frame.Visible=not shown end
            paint(); saveConfig()
        end)
        paint()
    end
    pickerArrow.MouseButton1Click:Connect(function()
        pickerOpen=not pickerOpen; picker.Size=UDim2.new(1,0,0,pickerOpen and 458 or 46); pickerArrow.Text=pickerOpen and "▲" or "▼"
    end)
    local mobileResetRow=Instance.new("TextButton",settings)
    mobileResetRow.Size=UDim2.new(1,0,0,42); mobileResetRow.LayoutOrder=15; mobileResetRow.BackgroundColor3=Color3.fromRGB(8,10,13); mobileResetRow.BackgroundTransparency=0; mobileResetRow.BorderSizePixel=0
    mobileResetRow.Text="RESET MOBILE BUTTONS"; mobileResetRow.TextColor3=C.white; mobileResetRow.TextSize=10; mobileResetRow.Font=Enum.Font.GothamBold; mobileResetRow.AutoButtonColor=false; guiCorner(mobileResetRow,10); guiStroke(mobileResetRow,Color3.fromRGB(95,105,115),1)
    local mobileResetSerial=0
    local function resetMobileButtons()
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode({})) end)
        if mobileButtonsEnabled and buildMobileButtons then buildMobileButtons() end
        saveConfig()
    end
    local function showMobileResetDone()
        mobileResetSerial=mobileResetSerial+1
        local serial=mobileResetSerial
        resetMobileButtons()
        mobileResetRow.Text="DONE"
        task.delay(2,function()
            if mobileResetRow and mobileResetRow.Parent and mobileResetSerial==serial then
                mobileResetRow.Text="RESET MOBILE BUTTONS"
            end
        end)
    end
    -- MouseButton1Click is emitted by Roblox for both desktop clicks and
    -- touchscreen taps, so the label behaves identically on every device.
    mobileResetRow.MouseButton1Click:Connect(showMobileResetDone)
    local hideUiRow=addActionRow(settings,"Hide UI","GuiHide",nil,4.9)
    local hideUiKey=hideUiRow:FindFirstChild("InlineKeybind_GuiHide")
    if hideUiKey then hideUiKey.Position=UDim2.new(1,-56,0.5,-10) end
    addToggleRow(settings,"Lock UI",uiLocked,5,nil,function(on) if GuiRefs.setUiLocked then GuiRefs.setUiLocked(on) else uiLocked=on end; saveConfig() end)
    addSectLbl(settings,"RESET",17)
    local resetRow=Instance.new("Frame"); resetRow.Size=UDim2.new(1,0,0,38); resetRow.BackgroundColor3=C.row
    resetRow.BackgroundTransparency=0.5; resetRow.BorderSizePixel=0; resetRow.LayoutOrder=18; resetRow.Parent=settings
    guiCorner(resetRow,10); guiStroke(resetRow,C.divider,1)
    local resetLbl=Instance.new("TextLabel",resetRow); resetLbl.Size=UDim2.new(0.55,0,0,16); resetLbl.Position=UDim2.new(0,12,0,6)
    resetLbl.BackgroundTransparency=1; resetLbl.Text="Reset Settings"; resetLbl.TextColor3=C.text; resetLbl.TextSize=11; resetLbl.Font=Enum.Font.GothamBold; resetLbl.TextXAlignment=Enum.TextXAlignment.Left
    local resetBtn=Instance.new("TextButton",resetRow); resetBtn.Size=UDim2.new(0,52,0,22); resetBtn.Position=UDim2.new(1,-60,0.5,-11)
    resetBtn.BackgroundColor3=Color3.fromRGB(8,10,13); resetBtn.BackgroundTransparency=0; resetBtn.BorderSizePixel=0
    resetBtn.Text="RESET"; resetBtn.TextColor3=C.white; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold; guiCorner(resetBtn,7); guiStroke(resetBtn,Color3.fromRGB(95,105,115),1)
    local resetArmed=false
    resetBtn.MouseButton1Click:Connect(function()
        if resetArmed then resetAllSettings(); resetArmed=false; resetBtn.Text="RESET"; resetBtn.BackgroundColor3=Color3.fromRGB(8,10,13); return end
        resetArmed=true; resetBtn.Text="ARE U SURE?"; resetBtn.BackgroundColor3=Color3.fromRGB(135,24,30)
        task.delay(4,function() if resetArmed and resetBtn.Parent then resetArmed=false; resetBtn.Text="RESET"; resetBtn.BackgroundColor3=Color3.fromRGB(8,10,13) end end)
    end)
    local hov4=Instance.new("TextButton",resetRow); hov4.Size=UDim2.new(1,0,1,0); hov4.BackgroundTransparency=1; hov4.Text=""; hov4.ZIndex=0
    hov4.MouseEnter:Connect(function() tw(resetRow,{BackgroundTransparency=0.3}) end)
    hov4.MouseLeave:Connect(function() tw(resetRow,{BackgroundTransparency=0.5}) end)
    -- Same full-width control style as Reset Mobile Buttons.
    resetRow.Visible=false
    local resetSettingsButton=Instance.new("TextButton",settings); resetSettingsButton.Size=UDim2.new(1,0,0,42); resetSettingsButton.LayoutOrder=18; resetSettingsButton.BackgroundColor3=Color3.fromRGB(8,10,13); resetSettingsButton.BorderSizePixel=0; resetSettingsButton.Text="RESET SETTINGS"; resetSettingsButton.TextColor3=C.white; resetSettingsButton.TextSize=10; resetSettingsButton.Font=Enum.Font.GothamBold; resetSettingsButton.AutoButtonColor=false; guiCorner(resetSettingsButton,10); guiStroke(resetSettingsButton,Color3.fromRGB(95,105,115),1)
    local resetSettingsArmed=false
    resetSettingsButton.MouseButton1Click:Connect(function()
        if resetSettingsArmed then resetAllSettings(); resetSettingsArmed=false; resetSettingsButton.Text="RESET SETTINGS"; resetSettingsButton.BackgroundColor3=Color3.fromRGB(8,10,13); return end
        resetSettingsArmed=true; resetSettingsButton.Text="ARE U SURE?"; resetSettingsButton.BackgroundColor3=Color3.fromRGB(135,24,30)
        task.delay(4,function() if resetSettingsArmed and resetSettingsButton.Parent then resetSettingsArmed=false; resetSettingsButton.Text="RESET SETTINGS"; resetSettingsButton.BackgroundColor3=Color3.fromRGB(8,10,13) end end)
    end)
end)()

-- INTRO SETTINGS
-- CONFIG SHARE: a DRG header followed by an encoded payload keeps sharing
-- self-contained without a web server.
-- Apply an imported configuration immediately.  The regular loader above is
-- reused so imports and startup accept exactly the same settings.
function Dragon.applyImportedConfigNow(d)
    local ok=pcall(function() Dragon.applyConfigData(d) end)
    if not ok then return false end
    pcall(function()
        if Dragon.setGlobalAntiDie then Dragon.setGlobalAntiDie(antiDieEnabled) end
        if DragonApplyFpsCap then DragonApplyFpsCap() end
        if antiLagEnabled then
            if enableAntiLag then enableAntiLag() end
        else
            if disableAntiLag then disableAntiLag() end
        end
        if fpsBoostEnabled then
            if enableFPSBoost then enableFPSBoost() end
        else
            if disableFPSBoost then disableFPSBoost() end
        end
        if antiRagdollEnabled then
            if startAntiRagdoll then startAntiRagdoll() end
        else
            if stopAntiRagdoll then stopAntiRagdoll() end
        end
        if setInfJumpInternal then setInfJumpInternal(infJumpEnabled) end
        if Steal.AutoStealEnabled then
            if startAutoSteal then startAutoSteal() end
        else
            if stopAutoSteal then stopAutoSteal() end
        end
        if batCounterEnabled then
            if startBatCounter then startBatCounter() end
        else
            if stopBatCounter then stopBatCounter() end
        end
        if espEnabled then
            if startESP then startESP() end
        else
            if stopESP then stopESP() end
        end
        if enemySpeedEnabled then
            if startEnemySpeedESP then startEnemySpeedESP() end
        else
            if stopEnemySpeedESP then stopEnemySpeedESP() end
        end
        if autoBatEnabled then
            if queueAutoBatStart then queueAutoBatStart() elseif startBatAimbot then startBatAimbot() end
        elseif stopBatAimbot then stopBatAimbot() end
        if autoTPEnabled then
            if startAutoTP then startAutoTP() end
        else
            if stopAutoTP then stopAutoTP() end
        end
        if stretchRezEnabled then
            if enableStretchRez then enableStretchRez() end
        else
            if disableStretchRez then disableStretchRez() end
        end
        if Dragon.antiKick then
            if Dragon.enableAntiKick then Dragon.enableAntiKick() end
        else
            if Dragon.disableAntiKick then Dragon.disableAntiKick() end
        end
        if medusaCounterEnabled and setupMedusa then setupMedusa(LP.Character) end
        if Dragon.enemyRagdollTimerEnabled then
            if Dragon.startEnemyRagdollTimer then Dragon.startEnemyRagdollTimer() end
        else
            if Dragon.stopEnemyRagdollTimer then Dragon.stopEnemyRagdollTimer() end
        end
        if animPackName and animPackName~="OFF" and applyAnimPack then applyAnimPack(animPackName) end
        if applySnowAmbitiousVisualEffects then applySnowAmbitiousVisualEffects() end
        if SnowApplySkyTheme then SnowApplySkyTheme(SnowCurrentSkyTheme) end
        if refreshSnowExtraESP then refreshSnowExtraESP() end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    end)
    pcall(saveConfig)
    return true
end
-- Reserved short code.  The packaged build replaces this marker with the
-- owner's complete, validated DRG config code.
local FAJACO_CONFIG_CODE=[[DRG-EWPH-R2VC-EBDK-837S-QJA5.eyJlMDFBbGVydCI6dHJ1ZSwic3RlYWxCYXJTY2FsZSI6MSwiY29sb3JmdWxHcmFwaGljc0VuYWJsZWQiOnRydWUsImJhdENvdW50ZXJNb2RlIjoiVjEiLCJ0cEJhdE5vQ2FtQ29sbGlzaW9uIjpmYWxzZSwiYXV0b1RQRW5hYmxlZCI6ZmFsc2UsImZwc0NhcFZhbHVlIjoxNzAsInN0ZWFsQmFyQmFja2dyb3VuZFVybCI6InJieGFzc2V0aWQ6Ly8xMDcwNzU5MzUxMjEzNDciLCJsYWdnZXJBaW1ib3RTcGVlZCI6NDAsInN0ZWFsRHVyYXRpb24iOjEuMywiZHJhZ29uUHJvZmlsZUFsdGVybmF0ZSI6ZmFsc2UsImxhZ2dlclRvZ2dsZUtleSI6eyJrYiI6IksifSwicmFnZG9sbFN0ZWFsUGF1c2VTZWNvbmRzIjoxLjMsImxhZ2dlckNhcnJ5U3BlZWQiOjIwLCJhdXRvUmlnaHRLZXkiOnsia2IiOiJDIn0sImF1dG9QbGF5TW9kZSI6ZmFsc2UsImVuZW15UmFnZG9sbFRpbWVyRW5hYmxlZCI6ZmFsc2UsInJhZ2RvbGxHdWkiOnRydWUsInNwZWVkU3lzdGVtIjoiVjIiLCJtaXJyb3JUUERvd25FbmFibGVkIjpmYWxzZSwibW9iaWxlQnV0dG9uc1NpemUiOjgwLCJzdGVhbEJhclBvc2l0aW9uIjp7InlzIjowLjg3OTk5OTk5NTIzMTYyODQsInhzIjowLjUsInhvIjotMTY1LCJ5byI6MH0sImluZmluaXRlSnVtcCI6dHJ1ZSwiZXNwRW5hYmxlZCI6dHJ1ZSwiY2FycnlTcGVlZCI6MzAsImludHJvU29uZ0luZGV4IjoxMSwiZW5lbXlTcGVlZEVuYWJsZWQiOnRydWUsImhpdENpcmNsZUVuYWJsZWQiOmZhbHNlLCJieXBhc3NMYWdnZXJBaW1ib3RTcGVlZCI6NDAsImNvbGxhcHNlZFRhYk1vZGUiOiJGUkVFIiwibGFnZ2VyTW9kZUVuYWJsZWQiOmZhbHNlLCJib2R5TG9ja1JhbmdlIjo2MCwidHBCYXRBbnRpRGllIjp0cnVlLCJhbnRpUmFnZG9sbFZlcnNpb24iOiJWMSIsInRwQmF0S2V5Ijp7ImtiIjoiWSJ9LCJmcHNCb29zdEVuYWJsZWQiOmZhbHNlLCJzZW1pTW9kZSI6IlYxIiwiYXV0b0FmdGVyRHJvcE1vZGUiOiJBSU1CT1QiLCJpbnRyb1NraXBFbmFibGVkIjpmYWxzZSwic25vd1VpVGhlbWVOYW1lIjoiQklBTkNPIiwiZ3VpU2NhbGUiOjEuMTAwMDAwMDIzODQxODU4LCJhbmltUGFja05hbWUiOiJWYW1waXJlIiwiYmF0VjJTcGVlZCI6NTYuNSwiYXV0b0FmdGVyRHJvcEVuYWJsZWQiOmZhbHNlLCJpbnRyb1ZlcnNpb24iOjEsImJhdFNraW5Nb2RlIjoiTk9ORSIsImRyb3BCcmFpbnJvdEtleSI6eyJrYiI6IkYifSwic3RlYWxNb2RlIjo0LCJhdXRvQ2FycnlNb2RlIjoiT05fUElDS1VQIiwiYnlwYXNzQWltYm90U3BlZWQiOjU4LCJhaW1ib3ROb3JtYWxWZXJzaW9uIjoiVjMiLCJ0YWJzUG9zaXRpb24iOiJUT1AiLCJhaW1ib3RTcGVlZCI6NTgsImFudGlMYWciOnRydWUsImhlYWRsZXNzRW5hYmxlZCI6dHJ1ZSwic3dvcmRDb2xvck1vZGUiOiJERUZBVUxUIiwibG9nb0NpcmNsZUVuYWJsZWQiOmZhbHNlLCJ0cERvd25NZXRob2QiOiJOT1JNQUwiLCJ1aUF1dG9GYWRlRW5hYmxlZCI6ZmFsc2UsIm1vYmlsZUJ1dHRvbnNMb2NrZWQiOmZhbHNlLCJhdXRvUGxheVJvdXRlTW9kZSI6IkZVTEwiLCJsYWdnZXJTcGVlZCI6NDAsInN0ZWFsU3R5bGUiOiJTZW1pIiwia2V5YmluZHMiOnsiQXV0b0xlZnQiOnsia2IiOiJaIn0sIkF1dG9SaWdodCI6eyJrYiI6IkMifSwiQXV0b0JhdCI6eyJrYiI6IlgifSwiSW5zdGFSZXNldCI6eyJrYiI6IlQifSwiTGFnZ2VyVG9nZ2xlIjp7ImtiIjoiSyJ9LCJEcm9wQnJhaW5yb3QiOnsia2IiOiJGIn0sIlRQQmF0Ijp7ImtiIjoiWSJ9LCJTcGVlZFRvZ2dsZSI6eyJrYiI6IlEifSwiVFBGbG9vciI6eyJrYiI6IlIifSwiR3VpSGlkZSI6eyJrYiI6IlJpZ2h0Q29udHJvbCJ9LCJBdXRvUGxheSI6eyJrYiI6IloifX0sImNhcnJ5U3BlZWRBY3RpdmUiOmZhbHNlLCJiYXRDb3VudGVyIjp0cnVlLCJub3JtYWxTcGVlZCI6NjAsImF1dG9UUEhlaWdodCI6MjAsInRwRmxvb3JLZXkiOnsia2IiOiJSIn0sInVud2Fsa0VuYWJsZWQiOmZhbHNlLCJjdXN0b21HdWlCYWNrZ3JvdW5kVXJsIjoiIiwia29yYmxveE1vZGUiOiJSSUdIVCIsImZvcmNlSGl0IjpmYWxzZSwiZ3VpVHJhbnNwYXJlbmN5RW5hYmxlZCI6ZmFsc2UsImUwMUFsZXJ0U2NhbGUiOjEuMjUsImF1dG9TdGVhbEVuYWJsZWQiOnRydWUsInNub3dUaGVtZU5hbWUiOiJXSElURSIsImtleXMiOnsiY2lyY2xlIjoiWCIsImNhcnJ5TW9kZSI6IlEiLCJndWlIaWRlIjoiUmlnaHRDb250cm9sIiwiQXV0b0xlZnQiOiJaIiwiYXV0b0xlZnQiOiJaIiwibGFnZ2VyVG9nZ2xlIjoiSyIsImRyb3BCcmFpbnJvdCI6IkYiLCJJbnN0YVJlc2V0IjoiVCIsIlNwZWVkVG9nZ2xlIjoiUSIsImF1dG9SaWdodCI6IkMiLCJ0cEJhdCI6IlkiLCJzcGVlZCI6IlEiLCJUUEZsb29yIjoiUiIsInRwRG93biI6IlIiLCJBdXRvUmlnaHQiOiJDIn0sImJvZHlMb2NrIjpmYWxzZSwiYmFja2dyb3VuZEVuYWJsZWQiOnRydWUsImtvcmJsb3hFbmFibGVkIjp0cnVlLCJyYWdkb2xsU3RlYWwiOnRydWUsIm1vYmlsZUJ1dHRvblZpc2liaWxpdHkiOnsiRFJPUF9CUiI6dHJ1ZSwiQkFUX0FJTUJPVCI6dHJ1ZSwiQVVUT19SSUdIVCI6dHJ1ZSwiSU5TVEFfUkVTRVQiOnRydWUsIkNBUlJZX1NQRUVEIjp0cnVlLCJMQUdHRVJfTk9STUFMIjp0cnVlLCJMQUdHRVJfQ0FSUlkiOnRydWUsIlRQX0JBVCI6dHJ1ZSwiQVVUT19MRUZUIjp0cnVlLCJUUF9ET1dOIjp0cnVlfSwibWVkdXNhQ291bnRlciI6dHJ1ZSwiZHJvcEJyYWlucm90TW9kZSI6IkpVTVAiLCJzZW1pU3RvcFBlcmNlbnQiOjc1LCJlc3BMaW5lRW5hYmxlZCI6dHJ1ZSwibm9DYW1Db2xsaXNpb25FbmFibGVkIjpmYWxzZSwidHBCYXRBbnRpVm9pZCI6ZmFsc2UsIm1lZHVzYVNraW5Nb2RlIjoiTk9ORSIsImhvbGRBdEVuYWJsZWQiOmZhbHNlLCJoaWRlUGluZ1dhcm5lciI6dHJ1ZSwidGl0bGVJbmRleCI6MSwiZXNwQm94RW5hYmxlZCI6dHJ1ZSwiYmF0VjJFbmFibGVkIjpmYWxzZSwic3RlYWxCYXJMb2NrZWQiOnRydWUsImFpbWJvdE1vZGUiOiJBSU1CT1QiLCJsYXN0QmFja2dyb3VuZFVybCI6InJieGFzc2V0aWQ6Ly8xMDcwNzU5MzUxMjEzNDciLCJndWlQb3NpdGlvbiI6eyJ5cyI6MCwieHMiOjAsInhvIjoxMzM0LCJ5byI6MTA3fSwiaW50cm9CYWNrZ3JvdW5kSW5kZXgiOjEsInNub3dUaGVtZUJhY2tncm91bmRJbmRleCI6eyJCSUFOQ08iOjEsIkFaWlVSUk8iOjF9LCJtb3Rpb25CbHVyRW5hYmxlZCI6ZmFsc2UsImF1dG9Nb3ZlU3dpbmdJbnRlcnZhbCI6MC4zLCJhdXRvU3dpdGNoU3BlZWQiOmZhbHNlLCJhdXRvTW92ZVN3aW5nIjpmYWxzZSwic3RlYWxCYXJIaWRkZW4iOmZhbHNlLCJncmFiUmFkaXVzIjo2MCwic2t5VGhlbWUiOiJPZmYiLCJwZXJCdXR0b25EcmFnIjp0cnVlLCJndWlIaWRlS2V5Ijp7ImtiIjoiUmlnaHRDb250cm9sIn0sImZvdlZhbHVlIjo4MCwiYW5pbVBhY2tFbmFibGVkIjp0cnVlLCJhdXRvTGVmdEtleSI6eyJrYiI6IloifSwiYWltYm90QnlwYXNzVmVyc2lvbiI6IlYzIiwibWVkdXNhU291bmRzRW5hYmxlZCI6ZmFsc2UsImJhdFNvdW5kc0VuYWJsZWQiOmZhbHNlLCJrb3JibG94TGFzdE1vZGUiOiJSSUdIVCIsInVpTG9ja2VkIjpmYWxzZSwiYXV0b0NhcnJ5U3RlYWxSYW5nZSI6MTAsImNpcmNsZUJ1dHRvbnNFbmFibGVkIjpmYWxzZSwiYXV0b1N3aW5nIjp0cnVlLCJiYWNrZ3JvdW5kSW5kZXgiOjEsInRwQmF0RnJlZUNhbWVyYSI6ZmFsc2UsIm1vYmlsZUJ1dHRvbnNFbmFibGVkIjpmYWxzZSwic3RyZXRjaFJlelNjYWxlIjoyLCJzdHJldGNoUmV6IjpmYWxzZSwicGVyZm9ybWFuY2VQcm9maWxlIjoiUVVBTElUWSIsInN0ZWFsUmFkaWkiOnsiTm9ybWFsIjo2MCwiU2VtaSI6NjB9LCJhaW1ib3RBZnRlckhpdCI6ZmFsc2UsImFudGlLaWNrIjp0cnVlLCJhbnRpRGllRW5hYmxlZCI6dHJ1ZSwiaW5mSnVtcE1vZGUiOiJob2xkIiwiYXV0b0JhdCI6ZmFsc2UsImJvZHlMb2NrTW9kZSI6IlBFUk0iLCJ0cEJhdEF1dG9EaXNhYmxlT25IaXQiOmZhbHNlLCJhdXRvQmF0S2V5Ijp7ImtiIjoiWCJ9LCJzcGVlZFRvZ2dsZUtleSI6eyJrYiI6IlEifSwiYW50aVJhZ2RvbGwiOnRydWV9]]
do
    local settings=CategoryRefs.contents["Settings"]
    if settings then
        local B64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local function enc(data)
            return ((data:gsub('.',function(x) local n=x:byte(); local r=""; for i=8,1,-1 do r=r..(n%2^i-n%2^(i-1)>0 and "1" or "0") end; return r end).."0000"):gsub("%d%d%d?%d?%d?%d?",function(x) if #x<6 then return "" end; local n=0; for i=1,6 do if x:sub(i,i)=="1" then n=n+2^(6-i) end end; return B64:sub(n+1,n+1) end)..({"","==","="})[#data%3+1])
        end
        local function dec(data)
            data=data:gsub("[^"..B64.."=]","")
            local bits=data:gsub('.',function(x) if x=="=" then return "" end; local n=B64:find(x,1,true)-1; local r=""; for i=6,1,-1 do r=r..(n%2^i-n%2^(i-1)>0 and "1" or "0") end; return r end)
            return bits:gsub("%d%d%d%d%d%d%d%d",function(x) local n=0; for i=1,8 do if x:sub(i,i)=="1" then n=n+2^(8-i) end end; return string.char(n) end)
        end
        local function header()
            local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; local t={}
            for b=1,5 do local s=""; for i=1,4 do local p=math.random(1,#chars); s=s..chars:sub(p,p) end; t[b]=s end
            return "DRG-"..table.concat(t,"-")
        end
        addSectLbl(settings,"CONFIG GENERATOR",16.4)
        local row=Instance.new("Frame",settings); row.Name="ConfigGenerator"; row.Size=UDim2.new(1,0,0,250); row.LayoutOrder=16.5; row.BackgroundColor3=Color3.fromRGB(8,12,18); row.BackgroundTransparency=.18; row.BorderSizePixel=0; guiCorner(row,11); guiStroke(row,Color3.fromRGB(80,170,220),1).Transparency=.22
        local logo=Instance.new("ImageLabel",row); logo.Size=UDim2.fromOffset(40,40); logo.Position=UDim2.new(0,10,0,8); logo.BackgroundTransparency=1; logo.Image="rbxassetid://91781095721218"; logo.ScaleType=Enum.ScaleType.Fit
        local title=Instance.new("TextLabel",row); title.Size=UDim2.new(1,-66,0,20); title.Position=UDim2.new(0,60,0,9); title.BackgroundTransparency=1; title.Text="CONFIG GENERATOR"; title.TextColor3=C.white; title.TextSize=11; title.Font=Enum.Font.GothamBold; title.TextXAlignment=Enum.TextXAlignment.Left
        local genNote=Instance.new("TextLabel",row); genNote.Size=UDim2.new(1,-66,0,20); genNote.Position=UDim2.new(0,60,0,27); genNote.BackgroundTransparency=1; genNote.Text="Generate a code from your current config."; genNote.TextColor3=C.textDim; genNote.TextSize=8; genNote.Font=Enum.Font.Gotham; genNote.TextXAlignment=Enum.TextXAlignment.Left
        local function box(y,placeholder)
            local b=Instance.new("TextBox",row); b.Name="ConfigCodeField"; b.Text=""; b.Size=UDim2.new(1,-20,0,32); b.Position=UDim2.new(0,10,0,y); b.BackgroundColor3=Color3.fromRGB(3,5,8); b.BorderSizePixel=0; b.ClipsDescendants=true; b.ClearTextOnFocus=false; b.MultiLine=false; b.TextTruncate=Enum.TextTruncate.AtEnd; b.PlaceholderText=placeholder; b.PlaceholderColor3=Color3.fromRGB(210,210,215); b.TextColor3=Color3.fromRGB(255,255,255); b.TextSize=8; b.Font=Enum.Font.Code; b.TextXAlignment=Enum.TextXAlignment.Left; guiCorner(b,7); guiStroke(b,Color3.fromRGB(65,110,140),1); enableMobileTextEntry(b); return b
        end
        local out=box(55,"")
        local function forceButtonColor(button,color)
            button.BackgroundColor3=color
            button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                if button.Parent and button.BackgroundColor3~=color then
                    task.defer(function() if button.Parent then button.BackgroundColor3=color end end)
                end
            end)
        end
        local gen=Instance.new("TextButton",row); gen.Size=UDim2.new(1,-20,0,28); gen.Position=UDim2.new(0,10,0,94); gen.BackgroundColor3=Color3.fromRGB(45,155,92); gen.BorderSizePixel=0; gen.Text="GENERATE + COPY"; gen.TextColor3=Color3.fromRGB(255,255,255); gen.TextSize=9; gen.Font=Enum.Font.GothamBold; guiCorner(gen,7)
        forceButtonColor(gen,Color3.fromRGB(45,155,92))
        local loaderTitle=Instance.new("TextLabel",row); loaderTitle.Size=UDim2.new(1,-20,0,18); loaderTitle.Position=UDim2.new(0,10,0,128); loaderTitle.BackgroundTransparency=1; loaderTitle.Text="CONFIG LOADER"; loaderTitle.TextColor3=C.white; loaderTitle.TextSize=10; loaderTitle.Font=Enum.Font.GothamBold; loaderTitle.TextXAlignment=Enum.TextXAlignment.Left
        local loaderNote=Instance.new("TextLabel",row); loaderNote.Size=UDim2.new(1,-20,0,16); loaderNote.Position=UDim2.new(0,10,0,145); loaderNote.BackgroundTransparency=1; loaderNote.Text="Paste a code to load its settings instantly."; loaderNote.TextColor3=C.textDim; loaderNote.TextSize=8; loaderNote.Font=Enum.Font.Gotham; loaderNote.TextXAlignment=Enum.TextXAlignment.Left
        local incoming=box(169,"")
        local imp=Instance.new("TextButton",row); imp.Size=UDim2.new(.5,-14,0,28); imp.Position=UDim2.new(0,10,0,207); imp.BackgroundColor3=Color3.fromRGB(45,155,92); imp.BorderSizePixel=0; imp.Text="IMPORT"; imp.TextColor3=Color3.fromRGB(255,255,255); imp.TextSize=9; imp.Font=Enum.Font.GothamBold; guiCorner(imp,7)
        forceButtonColor(imp,Color3.fromRGB(45,155,92))
        local clear=Instance.new("TextButton",row); clear.Size=UDim2.new(.5,-14,0,28); clear.Position=UDim2.new(.5,4,0,207); clear.BackgroundColor3=Color3.fromRGB(180,48,58); clear.BorderSizePixel=0; clear.Text="CLEAR"; clear.TextColor3=Color3.fromRGB(255,255,255); clear.TextSize=9; clear.Font=Enum.Font.GothamBold; guiCorner(clear,7)
        local status=Instance.new("TextLabel",row); status.Size=UDim2.new(1,-20,0,14); status.Position=UDim2.new(0,10,0,234); status.BackgroundTransparency=1; status.Text=""; status.TextColor3=C.textDim; status.TextSize=8; status.Font=Enum.Font.Gotham; status.TextXAlignment=Enum.TextXAlignment.Center
        local function say(t,c) status.Text=t; status.TextColor3=c or C.textDim end
        local function stripKeybinds(cfg)
            -- Config sharing intentionally preserves every setting except
            -- personal keyboard/controller bindings.
            cfg.keybinds=nil; cfg.keys=nil
            for _,name in ipairs({"dropBrainrotKey","autoLeftKey","autoRightKey","autoBatKey","laggerToggleKey","laggerCarryKey","tpBatKey","tpFloorKey","guiHideKey","speedToggleKey","batV2Key"}) do cfg[name]=nil end
            return cfg
        end
        clear.MouseButton1Click:Connect(function() incoming.Text=""; say("Import field cleared.",C.textDim) end)
        gen.MouseButton1Click:Connect(function()
            saveConfig()
            if not(readfile and isfile and isfile(Dragon_CONFIG_FILE)) then say("Local config files are unavailable.",Color3.fromRGB(255,130,130)); return end
            local ok,json=pcall(function() return readfile(Dragon_CONFIG_FILE) end)
            if not ok or type(json)~="string" then say("Could not read the saved config.",Color3.fromRGB(255,130,130)); return end
            local parsed,config=pcall(function() return HS:JSONDecode(json) end)
            if not parsed or type(config)~="table" then say("Could not prepare the config.",Color3.fromRGB(255,130,130)); return end
            json=HS:JSONEncode(stripKeybinds(config))
            out.Text=header().."."..enc(json); if setclipboard then pcall(function() setclipboard(out.Text) end) end; say("Full config generated — keybinds excluded.",C.green)
        end)
        imp.MouseButton1Click:Connect(function()
            -- Keep the full special config out of the TextBox: large values
            -- can be visually truncated by some executors before matching.
            local candidate=incoming.Text or ""
            if candidate:upper():gsub("%s+","")=="FAJACO" then candidate=FAJACO_CONFIG_CODE end
            local h,p=candidate:match("^(DRG%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w)%.(.+)$")
            if not h or not p then say("Invalid DRG code.",Color3.fromRGB(255,130,130)); return end
            local ok,json=pcall(dec,p); local valid,decoded=false,nil
            if ok then valid,decoded=pcall(function() return HS:JSONDecode(json) end) end
            if not valid or type(decoded)~="table" then say("Damaged or invalid config code.",Color3.fromRGB(255,130,130)); return end
            stripKeybinds(decoded)
            json=HS:JSONEncode(decoded)
            if not writefile or not pcall(function() writefile(Dragon_CONFIG_FILE,json) end) then say("Could not save the imported config.",Color3.fromRGB(255,130,130)); return end
            if Dragon.applyImportedConfigNow and Dragon.applyImportedConfigNow(decoded) then
                say("Config loaded now.",C.green)
            else
                say("Config saved, but could not apply it now.",Color3.fromRGB(255,190,100))
            end
        end)

        -- Separate placeholder card for the owner's future config.  It has no
        -- config connected yet; the second press is deliberately required.
        addSectLbl(settings,"OWNERS CONFIG",16.6)
        local fajaco=Instance.new("Frame",settings); fajaco.Name="FajacoConfig"; fajaco.Size=UDim2.new(1,0,0,66); fajaco.LayoutOrder=16.7; fajaco.BackgroundColor3=Color3.fromRGB(20,12,14); fajaco.BackgroundTransparency=.18; fajaco.BorderSizePixel=0; guiCorner(fajaco,11); guiStroke(fajaco,Color3.fromRGB(225,65,75),1).Transparency=.15
        local avatar=Instance.new("ImageLabel",fajaco); avatar.Name="FajacoAvatar"; avatar.Size=UDim2.fromOffset(46,46); avatar.Position=UDim2.new(0,10,0,10); avatar.BackgroundColor3=Color3.fromRGB(35,35,40); avatar.BorderSizePixel=0; avatar.Image=""; avatar.ScaleType=Enum.ScaleType.Crop; guiCorner(avatar,99)
        task.spawn(function()
            local ok,userId=pcall(function() return Players:GetUserIdFromNameAsync("fajaco1") end)
            if ok and userId and avatar.Parent then avatar.Image="rbxthumb://type=AvatarHeadShot&id="..userId.."&w=150&h=150" end
        end)
        local fajacoTitle=Instance.new("TextLabel",fajaco); fajacoTitle.Size=UDim2.new(0.42,0,0,18); fajacoTitle.Position=UDim2.new(0,66,0,11); fajacoTitle.BackgroundTransparency=1; fajacoTitle.Text="FAJACO'S CONFIG"; fajacoTitle.TextColor3=Color3.fromRGB(255,255,255); fajacoTitle.TextSize=10; fajacoTitle.Font=Enum.Font.GothamBold; fajacoTitle.TextXAlignment=Enum.TextXAlignment.Left
        local fajacoSub=Instance.new("TextLabel",fajaco); fajacoSub.Size=UDim2.new(0.42,0,0,17); fajacoSub.Position=UDim2.new(0,66,0,31); fajacoSub.BackgroundTransparency=1; fajacoSub.Text="Owner preset"; fajacoSub.TextColor3=C.textDim; fajacoSub.TextSize=8; fajacoSub.Font=Enum.Font.Gotham; fajacoSub.TextXAlignment=Enum.TextXAlignment.Left
        local fajacoButton=Instance.new("TextButton",fajaco); fajacoButton.Size=UDim2.new(0,112,0,30); fajacoButton.Position=UDim2.new(1,-122,.5,-15); fajacoButton.BackgroundColor3=Color3.fromRGB(45,155,92); fajacoButton.BorderSizePixel=0; fajacoButton.Text="LOAD"; fajacoButton.TextColor3=Color3.fromRGB(255,255,255); fajacoButton.TextSize=9; fajacoButton.Font=Enum.Font.GothamBold; guiCorner(fajacoButton,7)
        forceButtonColor(fajacoButton,Color3.fromRGB(45,155,92))
        local armed=false
        fajacoButton.MouseButton1Click:Connect(function()
            if not armed then
                armed=true; fajacoButton.Text="PRESS AGAIN"; fajacoButton.BackgroundColor3=Color3.fromRGB(65,230,120)
                task.delay(3,function() if armed and fajacoButton.Parent then armed=false; fajacoButton.Text="LOAD"; fajacoButton.BackgroundColor3=Color3.fromRGB(35,205,95) end end)
                return
            end
            armed=false
            local _,payload=FAJACO_CONFIG_CODE:match("^(DRG%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w%-%w%w%w%w)%.(.+)$")
            local ok,json=false,nil
            if payload then ok,json=pcall(dec,payload) end
            local valid,config=false,nil
            if ok then valid,config=pcall(function() return HS:JSONDecode(json) end) end
            if valid and type(config)=="table" then
                stripKeybinds(config)
                if Dragon.applyImportedConfigNow and Dragon.applyImportedConfigNow(config) then
                    fajacoButton.Text="LOADED"; fajacoButton.BackgroundColor3=Color3.fromRGB(45,175,85)
                else
                    fajacoButton.Text="FAILED"; fajacoButton.BackgroundColor3=Color3.fromRGB(225,28,38)
                end
            else
                fajacoButton.Text="INVALID"; fajacoButton.BackgroundColor3=Color3.fromRGB(225,28,38)
            end
            task.delay(2,function() if fajacoButton.Parent then fajacoButton.Text="LOAD"; fajacoButton.BackgroundColor3=Color3.fromRGB(35,205,95) end end)
        end)
    end
end

-- INTRO SETTINGS
;(function()
    local settings=CategoryRefs.contents["Settings"]
    if not settings then return end
    addSectLbl(settings,"INTRO",19)
    addToggleRow(settings,"Skip Intro",introSkipEnabled,22,nil,function(on)
        introSkipEnabled=on==true; saveConfig()
    end)
    local introPicker=nil
    local introVersionRow=Instance.new("Frame",settings); introVersionRow.Name="IntroVersionSelector"; introVersionRow.Size=UDim2.new(1,0,0,66); introVersionRow.BackgroundColor3=C.row; introVersionRow.BackgroundTransparency=0.5; introVersionRow.BorderSizePixel=0; introVersionRow.LayoutOrder=19; introVersionRow.Visible=false
    guiCorner(introVersionRow,10); guiStroke(introVersionRow,C.divider,1)
    local introVersionTitle=Instance.new("TextLabel",introVersionRow); introVersionTitle.Size=UDim2.new(1,-24,0,16); introVersionTitle.Position=UDim2.new(0,12,0,6); introVersionTitle.BackgroundTransparency=1; introVersionTitle.Text="INTRO SELECTOR"; introVersionTitle.TextColor3=C.text; introVersionTitle.TextSize=11; introVersionTitle.Font=Enum.Font.GothamBold; introVersionTitle.TextXAlignment=Enum.TextXAlignment.Left
    local introVersionPrev=Instance.new("TextButton",introVersionRow); introVersionPrev.Size=UDim2.new(0,30,0,26); introVersionPrev.Position=UDim2.new(0,12,0,31); introVersionPrev.BackgroundColor3=Color3.fromRGB(8,10,13); introVersionPrev.BackgroundTransparency=.15; introVersionPrev.BorderSizePixel=0; introVersionPrev.Text="‹"; introVersionPrev.TextColor3=C.white; introVersionPrev.TextSize=18; introVersionPrev.Font=Enum.Font.GothamBold; guiCorner(introVersionPrev,7); guiStroke(introVersionPrev,Color3.fromRGB(95,105,115),1)
    local introVersionValue=Instance.new("TextLabel",introVersionRow); introVersionValue.Size=UDim2.new(1,-96,0,26); introVersionValue.Position=UDim2.new(0,48,0,32); introVersionValue.BackgroundTransparency=1; introVersionValue.TextColor3=C.white; introVersionValue.TextSize=10; introVersionValue.Font=Enum.Font.GothamBold; introVersionValue.TextXAlignment=Enum.TextXAlignment.Center; introVersionValue.ClipsDescendants=true
    local introVersionNext=Instance.new("TextButton",introVersionRow); introVersionNext.Size=UDim2.new(0,30,0,26); introVersionNext.Position=UDim2.new(1,-42,0,31); introVersionNext.BackgroundColor3=Color3.fromRGB(8,10,13); introVersionNext.BackgroundTransparency=.15; introVersionNext.BorderSizePixel=0; introVersionNext.Text="›"; introVersionNext.TextColor3=C.white; introVersionNext.TextSize=18; introVersionNext.Font=Enum.Font.GothamBold; guiCorner(introVersionNext,7); guiStroke(introVersionNext,Color3.fromRGB(95,105,115),1)
    local introV1Assets={"rbxassetid://108848568598764","rbxassetid://132946597254298","rbxassetid://132542543878607","rbxassetid://77214765454888"}
    local function paintIntroVersionPreview()
        for _,child in ipairs(introVersionValue:GetChildren()) do if child:IsA("ImageLabel") then child:Destroy() end end
        introVersionValue.Text=""
        if introVersion==1 then
            for i,asset in ipairs(introV1Assets) do
                local preview=Instance.new("ImageLabel",introVersionValue)
                preview.Size=UDim2.new(0,27,0,25); preview.Position=UDim2.new(.5,-57+(i-1)*29,.5,-12)
                preview.BackgroundTransparency=1; preview.Image=asset; preview.ScaleType=Enum.ScaleType.Fit
            end
        else
            local preview=Instance.new("ImageLabel",introVersionValue)
            preview.Size=UDim2.new(0,78,0,25); preview.Position=UDim2.new(.5,-39,.5,-12)
            preview.BackgroundTransparency=1; preview.Image=Dragon_INTRO_BACKGROUNDS[1]; preview.ScaleType=Enum.ScaleType.Crop
            guiCorner(preview,5)
        end
    end
    local function setIntroVersion(index,shouldSave)
        introVersion=(index-1)%2+1; paintIntroVersionPreview()
        if introPicker then introPicker.Visible=(introVersion==2) end
        if shouldSave then saveConfig() end
    end
    introVersionPrev.MouseButton1Click:Connect(function() setIntroVersion(introVersion-1,true) end)
    introVersionNext.MouseButton1Click:Connect(function() setIntroVersion(introVersion+1,true) end)
    introPicker=Instance.new("Frame",settings); introPicker.Name="ClassicIntroStyleSelector"; introPicker.Size=UDim2.new(1,0,0,92); introPicker.BackgroundColor3=C.row; introPicker.BackgroundTransparency=0.5; introPicker.BorderSizePixel=0; introPicker.LayoutOrder=20; introPicker.Visible=false
    guiCorner(introPicker,10); guiStroke(introPicker,C.divider,1)
    local introPickerTitle=Instance.new("TextLabel",introPicker); introPickerTitle.Size=UDim2.new(1,-24,0,16); introPickerTitle.Position=UDim2.new(0,12,0,6); introPickerTitle.BackgroundTransparency=1; introPickerTitle.Text="INTRO STYLE"; introPickerTitle.TextColor3=C.text; introPickerTitle.TextSize=11; introPickerTitle.Font=Enum.Font.GothamBold; introPickerTitle.TextXAlignment=Enum.TextXAlignment.Left
    local introPrev=Instance.new("TextButton",introPicker); introPrev.Size=UDim2.new(0,30,0,42); introPrev.Position=UDim2.new(0,12,0,38); introPrev.BackgroundColor3=Color3.fromRGB(8,10,13); introPrev.BackgroundTransparency=0.15; introPrev.BorderSizePixel=0; introPrev.Text="‹"; introPrev.TextColor3=C.white; introPrev.TextSize=22; introPrev.Font=Enum.Font.GothamBold; introPrev.AutoButtonColor=false; guiCorner(introPrev,7); guiStroke(introPrev,Color3.fromRGB(95,105,115),1)
    local introNext=Instance.new("TextButton",introPicker); introNext.Size=UDim2.new(0,30,0,42); introNext.Position=UDim2.new(1,-42,0,38); introNext.BackgroundColor3=Color3.fromRGB(8,10,13); introNext.BackgroundTransparency=0.15; introNext.BorderSizePixel=0; introNext.Text="›"; introNext.TextColor3=C.white; introNext.TextSize=22; introNext.Font=Enum.Font.GothamBold; introNext.AutoButtonColor=false; guiCorner(introNext,7); guiStroke(introNext,Color3.fromRGB(95,105,115),1)
    local introPreview=Instance.new("Frame",introPicker); introPreview.Size=UDim2.new(1,-96,0,44); introPreview.Position=UDim2.new(0,48,0,37); introPreview.BackgroundTransparency=1; introPreview.ClipsDescendants=true
    local introCards={}
    local function refreshIntroCards()
        for _,card in ipairs(introCards) do card:Destroy() end; introCards={}
        for slot=1,3 do
            local imageIndex=(introBackgroundIndex+slot-2-1)%#Dragon_INTRO_BACKGROUNDS+1
            local card=Instance.new("ImageButton",introPreview); card.Size=UDim2.new(0,54,0,42); card.Position=UDim2.new(0,(slot-1)*60,0,1); card.BackgroundColor3=Color3.fromRGB(8,10,13); card.BackgroundTransparency=0.12; card.BorderSizePixel=0; card.AutoButtonColor=false; card.Image=Dragon_INTRO_BACKGROUNDS[imageIndex]; card.ScaleType=Enum.ScaleType.Crop
            guiCorner(card,7); local stroke=guiStroke(card,imageIndex==introBackgroundIndex and C.blue or Color3.fromRGB(95,105,115),imageIndex==introBackgroundIndex and 1.5 or 1); stroke.Transparency=imageIndex==introBackgroundIndex and 0 or 0.55
            card.MouseButton1Click:Connect(function() introBackgroundIndex=imageIndex; saveConfig(); playDragonIntroBackgroundPreview(introBackgroundIndex); refreshIntroCards() end)
            table.insert(introCards,card)
        end
    end
    introPrev.MouseButton1Click:Connect(function() introBackgroundIndex=(introBackgroundIndex-2)%#Dragon_INTRO_BACKGROUNDS+1; saveConfig(); playDragonIntroBackgroundPreview(introBackgroundIndex); refreshIntroCards() end)
    introNext.MouseButton1Click:Connect(function() introBackgroundIndex=introBackgroundIndex%#Dragon_INTRO_BACKGROUNDS+1; saveConfig(); playDragonIntroBackgroundPreview(introBackgroundIndex); refreshIntroCards() end)
    refreshIntroCards()
    setIntroVersion(introVersion,false)
    local songRow=Instance.new("Frame",settings); songRow.Name="IntroSongSelector"; songRow.Size=UDim2.new(1,0,0,66); songRow.BackgroundColor3=C.row; songRow.BackgroundTransparency=0.5; songRow.BorderSizePixel=0; songRow.LayoutOrder=21; songRow.Visible=true
    guiCorner(songRow,10); guiStroke(songRow,C.divider,1)
    local songTitle=Instance.new("TextLabel",songRow); songTitle.Size=UDim2.new(1,-24,0,16); songTitle.Position=UDim2.new(0,12,0,6); songTitle.BackgroundTransparency=1; songTitle.Text="INTRO SONG"; songTitle.TextColor3=C.text; songTitle.TextSize=11; songTitle.Font=Enum.Font.GothamBold; songTitle.TextXAlignment=Enum.TextXAlignment.Left
    local songValue=Instance.new("TextLabel",songRow); songValue.Size=UDim2.new(1,-96,0,26); songValue.Position=UDim2.new(0,48,0,32); songValue.BackgroundTransparency=1; songValue.TextColor3=C.white; songValue.TextSize=11; songValue.Font=Enum.Font.GothamBold; songValue.TextXAlignment=Enum.TextXAlignment.Center
    local songLeft=Instance.new("TextButton",songRow); songLeft.Size=UDim2.new(0,30,0,26); songLeft.Position=UDim2.new(0,12,0,31); songLeft.BackgroundColor3=Color3.fromRGB(8,10,13); songLeft.BackgroundTransparency=0.15; songLeft.BorderSizePixel=0; songLeft.Text="‹"; songLeft.TextColor3=C.white; songLeft.TextSize=18; songLeft.Font=Enum.Font.GothamBold; songLeft.AutoButtonColor=false; guiCorner(songLeft,7); guiStroke(songLeft,Color3.fromRGB(95,105,115),1)
    local songRight=Instance.new("TextButton",songRow); songRight.Size=UDim2.new(0,30,0,26); songRight.Position=UDim2.new(1,-42,0,31); songRight.BackgroundColor3=Color3.fromRGB(8,10,13); songRight.BackgroundTransparency=0.15; songRight.BorderSizePixel=0; songRight.Text="›"; songRight.TextColor3=C.white; songRight.TextSize=18; songRight.Font=Enum.Font.GothamBold; songRight.AutoButtonColor=false; guiCorner(songRight,7); guiStroke(songRight,Color3.fromRGB(95,105,115),1)
    local function setIntroSong(index,preview)
        introSongIndex=(index-1)%#Dragon_INTRO_SONGS+1; songValue.Text="Song "..introSongIndex; saveConfig()
        if preview then playDragonIntroSongPreview(introSongIndex) end
    end
    setIntroSong(introSongIndex,false)
    songLeft.MouseButton1Click:Connect(function() setIntroSong(introSongIndex-1,true) end)
    songRight.MouseButton1Click:Connect(function() setIntroSong(introSongIndex+1,true) end)

    -- Kept at the very end of Settings.  OPEN restores the full Dragon chooser so
    -- a profile change is a deliberate action rather than an accidental tap.
    addSectLbl(settings,"PERFORMANCE PROFILE",30)
    local profileRow=Instance.new("Frame",settings); profileRow.Name="PerformanceProfileSelector"; profileRow.Size=UDim2.new(1,0,0,76); profileRow.BackgroundColor3=C.row; profileRow.BackgroundTransparency=.5; profileRow.BorderSizePixel=0; profileRow.LayoutOrder=31
    guiCorner(profileRow,10); guiStroke(profileRow,C.divider,1)
    local profileHint=Instance.new("TextLabel",profileRow); profileHint.Position=UDim2.new(0,12,0,9); profileHint.Size=UDim2.new(1,-112,0,18); profileHint.BackgroundTransparency=1; profileHint.Text="Current: "..(DragonPerformanceProfile or "NOT SELECTED"); profileHint.TextColor3=C.text; profileHint.TextSize=10; profileHint.Font=Enum.Font.GothamBold; profileHint.TextXAlignment=Enum.TextXAlignment.Left
    local profileNote=Instance.new("TextLabel",profileRow); profileNote.Position=UDim2.new(0,12,0,30); profileNote.Size=UDim2.new(1,-112,0,32); profileNote.BackgroundTransparency=1; profileNote.Text="Open the Dragon profile panel. Re-execute after changing mode."; profileNote.TextColor3=C.textDim; profileNote.TextSize=9; profileNote.Font=Enum.Font.Gotham; profileNote.TextWrapped=true; profileNote.TextXAlignment=Enum.TextXAlignment.Left
    local openProfile=Instance.new("TextButton",profileRow); openProfile.Position=UDim2.new(1,-89,.5,-16); openProfile.Size=UDim2.new(0,77,0,32); openProfile.BackgroundColor3=Color3.fromRGB(0,0,0); openProfile.BackgroundTransparency=.16; openProfile.BorderSizePixel=0; openProfile.AutoButtonColor=false; openProfile.Text="OPEN"; openProfile.TextColor3=C.white; openProfile.TextSize=10; openProfile.Font=Enum.Font.GothamBold; guiCorner(openProfile,8); guiStroke(openProfile,Color3.fromRGB(60,60,60),1)
    openProfile.MouseButton1Click:Connect(function()
        if DragonOpenPerformanceProfilePicker then DragonOpenPerformanceProfilePicker(true) end
    end)
end)()


-- BACKGROUND PAGE (Background List with big previews + scroller)
;(function()
    local bgPage = CategoryRefs.contents["Settings"]
    if not bgPage then return end
    addSectLbl(bgPage, "BACKGROUND LIST", 0)

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 420)
    listFrame.BackgroundColor3 = C.row
    listFrame.BackgroundTransparency = 0.55
    listFrame.BorderSizePixel = 0
    listFrame.LayoutOrder = 1
    listFrame.Parent = bgPage
    listFrame.Visible = false -- Replaced by the compact arrow carousel below.
    guiCorner(listFrame, 12)
    guiStroke(listFrame, C.divider, 1)

    local title = Instance.new("TextLabel", listFrame)
    title.Size = UDim2.new(1, -16, 0, 22)
    title.Position = UDim2.new(0, 8, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "Background List  ·  tap a preview"
    title.TextColor3 = C.textDim
    title.TextSize = 11
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    local scroll = Instance.new("ScrollingFrame", listFrame)
    scroll.Name = "BackgroundList"
    scroll.Size = UDim2.new(1, -12, 1, -36)
    scroll.Position = UDim2.new(0, 6, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
    scroll.ScrollBarImageTransparency = 0.52
    scroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ElasticBehavior = Enum.ElasticBehavior.Always
    scroll.ZIndex = 5

    local lay = Instance.new("UIListLayout", scroll)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 10)
    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)

    local cardRefs = {}

    local function setSelectedVisual(sel)
        local selectedColor=SnowGetUiThemeColor()
        for i, rec in ipairs(cardRefs) do
            if rec.stroke then
                rec.stroke.Color = selectedColor
                rec.stroke.Thickness = 2
                rec.stroke.Transparency = (i == sel) and 0 or 1
            end
            if rec.badge then
                rec.badge.Visible = (i == sel)
            end
        end
        if cardRefs[0] then
            cardRefs[0].stroke.Color = selectedColor
            cardRefs[0].stroke.Thickness = 2
            cardRefs[0].stroke.Transparency = (sel == 0) and 0 or 1
            if cardRefs[0].badge then cardRefs[0].badge.Visible = (sel == 0) end
        end
    end

    -- OFF card
    do
        local card = Instance.new("TextButton", scroll)
        card.Size = UDim2.new(1, -8, 0, 56)
        card.BackgroundColor3 = Color3.fromRGB(18,18,22)
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.Text = ""
        card.LayoutOrder = 0
        card.ZIndex = 6
        guiCorner(card, 10)
        local st = guiStroke(card, Color3.fromRGB(60,60,70), 1)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "OFF  ·  No background"
        lbl.TextColor3 = C.text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 7
        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 64, 0, 20)
        badge.Position = UDim2.new(1, -74, 0.5, -10)
        badge.BackgroundColor3 = Color3.fromRGB(40,40,48)
        badge.Text = "ACTIVE"
        badge.TextColor3 = Color3.fromRGB(255,255,255)
        badge.TextSize = 9
        badge.Font = Enum.Font.GothamBold
        badge.ZIndex = 8
        badge.Visible = (backgroundIndex == 0)
        guiCorner(badge, 6)
        cardRefs[0] = {stroke = st, badge = badge}
        card.MouseButton1Click:Connect(function()
            applyBackgroundImage(0)
            setSelectedVisual(0)
            saveConfig()
        end)
    end

    for idx, entry in ipairs(BG_IMAGE_URLS) do
        local card = Instance.new("ImageButton", scroll)
        card.Size = UDim2.new(1, -8, 0, 130)
        card.BackgroundColor3 = Color3.fromRGB(12,12,16)
        card.BackgroundTransparency = 0.05
        card.Image = ""
        card.ScaleType = Enum.ScaleType.Crop
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.LayoutOrder = idx
        card.ZIndex = 6
        guiCorner(card, 12)
        local st = guiStroke(card, Color3.fromRGB(60,60,70), 1)

        local dim = Instance.new("Frame", card)
        dim.Size = UDim2.new(1, 0, 0, 32)
        dim.Position = UDim2.new(0, 0, 1, -32)
        dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dim.BackgroundTransparency = 0.35
        dim.BorderSizePixel = 0
        dim.ZIndex = 7
        guiCorner(dim, 12)

        local nameLbl = Instance.new("TextLabel", card)
        nameLbl.Size = UDim2.new(1, -90, 0, 22)
        nameLbl.Position = UDim2.new(0, 12, 1, -28)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "Background " .. tostring(idx)
        nameLbl.TextColor3 = Color3.fromRGB(240,240,245)
        nameLbl.TextSize = 12
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 8

        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 64, 0, 20)
        badge.Position = UDim2.new(1, -74, 1, -26)
        badge.BackgroundColor3 = Color3.fromRGB(40,40,48)
        badge.Text = "ACTIVE"
        badge.TextColor3 = Color3.fromRGB(255,255,255)
        badge.TextSize = 9
        badge.Font = Enum.Font.GothamBold
        badge.ZIndex = 8
        badge.Visible = (backgroundIndex == idx)
        guiCorner(badge, 6)

        cardRefs[idx] = {stroke = st, badge = badge, img = card}

        task.spawn(function()
            for _try = 1, 25 do
                local asset = bgLoadedAssets[idx]
                if asset and asset ~= "" then
                    card.Image = asset
                    break
                end
                if _try == 3 then
                    local a = downloadBgImage(entry)
                    if a ~= "" then
                        bgLoadedAssets[idx] = a
                        card.Image = a
                        break
                    end
                end
                task.wait(0.12)
            end
            if card.Image == "" then card.Image = entry.url end
        end)

        card.MouseButton1Click:Connect(function()
            applyBackgroundImage(idx)
            setSelectedVisual(idx)
            saveConfig()
        end)
    end

    task.defer(function()
        setSelectedVisual(backgroundIndex or 0)
        if backgroundIndex and backgroundIndex > 0 then
            applyBackgroundImage(backgroundIndex)
        end
    end)
    SnowRefreshBackgroundListVisual=function() setSelectedVisual(backgroundIndex or 0) end
end)()

-- Compact background carousel (no scrollbar)
;(function()
    local bgPage = CategoryRefs.contents["Settings"]
    if not bgPage then return end
    local carousel = Instance.new("Frame", bgPage)
    carousel.Name="BackgroundCarousel"; carousel.Size=UDim2.new(1,0,0,134); carousel.BackgroundColor3=Color3.fromRGB(0,0,0)
    carousel.BackgroundTransparency=0.3; carousel.BorderSizePixel=0; carousel.LayoutOrder=2
    guiCorner(carousel,12); local carouselStroke=guiStroke(carousel,Color3.fromRGB(70,130,150),1); carouselStroke.Transparency=0.55
    local label=Instance.new("TextLabel",carousel)
    label.Size=UDim2.new(1,-20,0,20); label.Position=UDim2.new(0,10,0,6); label.BackgroundTransparency=1
    label.Text="BACKGROUND IMAGE"; label.TextColor3=C.textDim; label.TextSize=10; label.Font=Enum.Font.GothamBold; label.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("TextButton",carousel)
    prev.Size=UDim2.new(0,22,0,42); prev.Position=UDim2.new(0,8,0,42); prev.BackgroundColor3=Color3.fromRGB(13,18,22); prev.BorderSizePixel=0
    prev.Text="‹"; prev.TextColor3=C.blue; prev.TextSize=28; prev.Font=Enum.Font.GothamMedium; prev.AutoButtonColor=false
    guiCorner(prev,8); local prevStroke=guiStroke(prev,Color3.fromRGB(70,130,150),1); prevStroke.Transparency=0.35
    local next=Instance.new("TextButton",carousel)
    next.Size=UDim2.new(0,22,0,42); next.Position=UDim2.new(1,-30,0,42); next.BackgroundColor3=Color3.fromRGB(13,18,22); next.BorderSizePixel=0
    next.Text="›"; next.TextColor3=C.blue; next.TextSize=28; next.Font=Enum.Font.GothamMedium; next.AutoButtonColor=false
    guiCorner(next,8); local nextStroke=guiStroke(next,Color3.fromRGB(70,130,150),1); nextStroke.Transparency=0.35
    local previewArea=Instance.new("Frame",carousel)
    -- Keep the "None" card well clear of the left arrow on the narrow GUI.
    previewArea.Size=UDim2.new(1,-120,0,48); previewArea.Position=UDim2.new(0,68,0,39); previewArea.BackgroundTransparency=1; previewArea.ClipsDescendants=false
    local customInput=Instance.new("TextBox",carousel)
    customInput.Name="CustomBackgroundAssetId"; customInput.Size=UDim2.new(1,-20,0,26); customInput.Position=UDim2.new(0,10,0,99)
    customInput.BackgroundColor3=Color3.fromRGB(20,22,26); customInput.BackgroundTransparency=.18; customInput.BorderSizePixel=0
    customInput.PlaceholderText="Custom background asset ID — press Enter"; customInput.PlaceholderColor3=Color3.fromRGB(165,170,176)
    customInput.Text=(customGuiBackgroundUrl or ""):gsub("rbxassetid://",""); customInput.TextColor3=C.white; customInput.TextSize=10; customInput.Font=Enum.Font.GothamBold; customInput.ClearTextOnFocus=false; customInput.ZIndex=6
    guiCorner(customInput,7); guiStroke(customInput,Color3.fromRGB(95,105,115),1); enableMobileTextEntry(customInput)
    local filteringGuiAsset=false
    customInput:GetPropertyChangedSignal("Text"):Connect(function()
        if filteringGuiAsset then return end
        local digits=tostring(customInput.Text):gsub("%D",""):sub(1,20)
        if customInput.Text~=digits then filteringGuiAsset=true; customInput.Text=digits; filteringGuiAsset=false end
    end)
    local cards={}
    local selected=(backgroundIndex==-1) and -1 or math.clamp(math.floor(backgroundIndex or 0),0,#BG_IMAGE_URLS)
    local function applySelected(index)
        selected=index
        applyBackgroundImage(index)
        saveConfig()
    end
    local function refresh()
        selected=(backgroundIndex==-1) and -1 or math.clamp(math.floor(backgroundIndex or selected),0,#BG_IMAGE_URLS)
        for _,card in ipairs(cards) do card:Destroy() end
        cards={}
        local first=math.clamp(selected-1,0,math.max(0,#BG_IMAGE_URLS-2))
        for slot=0,2 do
            local index=first+slot
            if index>#BG_IMAGE_URLS then break end
            local entry=BG_IMAGE_URLS[index]
            local card=Instance.new("ImageButton",previewArea)
            card.Name="BackgroundCard_"..tostring(index)
            card.Size=UDim2.new(0,54,0,46); card.Position=UDim2.new(0,slot*60,0,1); card.BackgroundColor3=Color3.fromRGB(9,9,11)
            card.BackgroundTransparency=0.15; card.BorderSizePixel=0; card.AutoButtonColor=false; card.ScaleType=Enum.ScaleType.Crop
            -- The selected card must render over its neighbours, especially
            -- the white outline on the None card.
            card.Image=(index==0) and "" or entry.url; card.ZIndex=(index==selected) and 7 or 5
            -- Thumbnails always show the source image without a theme tint.
            card.ImageColor3=Color3.fromRGB(255,255,255)
            local photoBorder=SnowGetUiThemeColor()
            guiCorner(card,7); local st=guiStroke(card,photoBorder,2); st.Transparency=(index==selected) and 0 or 1
            if index==0 then
                local none=Instance.new("TextLabel",card); none.Size=UDim2.new(1,0,1,0); none.BackgroundTransparency=1; none.Text="None"; none.TextColor3=Color3.fromRGB(210,220,225); none.TextSize=10; none.Font=Enum.Font.GothamBold; none.ZIndex=6
            end
            card.MouseButton1Click:Connect(function() applySelected(index); refresh() end)
            table.insert(cards,card)
        end
    end
    prev.MouseButton1Click:Connect(function()
        applySelected((selected-1)%(#BG_IMAGE_URLS+1)); refresh()
    end)
    next.MouseButton1Click:Connect(function()
        applySelected((selected+1)%(#BG_IMAGE_URLS+1)); refresh()
    end)
    customInput.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local id=tostring(customInput.Text):match("%d+")
        if not id then customInput.Text=(customGuiBackgroundUrl or ""):gsub("rbxassetid://",""); return end
        customGuiBackgroundUrl="rbxassetid://"..id
        customInput.Text=id; applyBackgroundImage(-1); selected=-1; saveConfig(); refresh()
    end)
    SnowRefreshBackgroundCarousel=refresh
    refresh()
    task.defer(function() applyBackgroundImage(selected) end)
end)()

-- Color squares live in the existing Settings panel, directly under the
-- position/theme controls. Every square is an active full GUI theme.
;(function()
    local page=CategoryRefs.contents["Settings"]
    if not page or true then return end -- Theme selection is temporarily disabled; the white theme is fixed.
    local row=Instance.new("Frame",page); row.Name="ThemeSwatches"; row.Size=UDim2.new(1,0,0,42); row.BackgroundTransparency=1; row.BorderSizePixel=0; row.LayoutOrder=3
    local layout=Instance.new("UIListLayout",row); layout.FillDirection=Enum.FillDirection.Horizontal; layout.Padding=UDim.new(0,10); layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; layout.VerticalAlignment=Enum.VerticalAlignment.Center
    local swatches={{"BIANCO",Color3.fromRGB(255,255,255)},{"AZZURRO",Color3.fromRGB(80,215,255)}}
    local buttons={}
    local function paint()
        for name,button in pairs(buttons) do
            local selected=(name==snowUiThemeName)
            local stroke=button:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency=1 end
            button.BackgroundTransparency=selected and 0 or .18
        end
    end
    for _,data in ipairs(swatches) do
        local name,color=data[1],data[2]
        local button=Instance.new("TextButton",row); button.Name="Theme_"..name; button.Size=UDim2.new(0,30,0,20); button.BackgroundColor3=color; button.BackgroundTransparency=.18; button.BorderSizePixel=0; button.Text=""; button.AutoButtonColor=false
        guiCorner(button,4); guiStroke(button,Color3.fromRGB(255,255,255),1).Transparency=.35
        buttons[name]=button
        button.MouseButton1Click:Connect(function()
            SnowApplyFullColorTheme(name,true)
            if SnowHideUiBorders then SnowHideUiBorders() end
            paint(); saveConfig()
        end)
    end
    paint()
end)()

-- TITLE SELECTOR
;(function()
    local page=CategoryRefs.contents["Settings"]
    if not page then return end
    local selector=Instance.new("Frame",page); selector.Name="TitleSelector"; selector.Size=UDim2.new(1,0,0,96); selector.BackgroundColor3=Color3.fromRGB(0,0,0); selector.BackgroundTransparency=0.3; selector.BorderSizePixel=0; selector.LayoutOrder=4; selector.Visible=(snowUiThemeName=="AZZURRO")
    guiCorner(selector,12); guiStroke(selector,Color3.fromRGB(70,130,150),1).Transparency=0.55
    local label=Instance.new("TextLabel",selector); label.Size=UDim2.new(1,-20,0,20); label.Position=UDim2.new(0,10,0,6); label.BackgroundTransparency=1; label.Text="TITLE SELECTOR"; label.TextColor3=C.textDim; label.TextSize=10; label.Font=Enum.Font.GothamBold; label.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("TextButton",selector); prev.Size=UDim2.new(0,28,0,42); prev.Position=UDim2.new(0,8,0,42); prev.BackgroundColor3=Color3.fromRGB(13,18,22); prev.BorderSizePixel=0; prev.Text="‹"; prev.TextColor3=C.blue; prev.TextSize=28; prev.Font=Enum.Font.GothamMedium; prev.AutoButtonColor=false; guiCorner(prev,8); guiStroke(prev,Color3.fromRGB(70,130,150),1).Transparency=0.35
    local next=Instance.new("TextButton",selector); next.Size=UDim2.new(0,28,0,42); next.Position=UDim2.new(1,-36,0,42); next.BackgroundColor3=Color3.fromRGB(13,18,22); next.BorderSizePixel=0; next.Text="›"; next.TextColor3=C.blue; next.TextSize=28; next.Font=Enum.Font.GothamMedium; next.AutoButtonColor=false; guiCorner(next,8); guiStroke(next,Color3.fromRGB(70,130,150),1).Transparency=0.35
    local preview=Instance.new("ImageLabel",selector); preview.Name="SelectedTitlePreview"; preview.Size=UDim2.new(1,-92,0,42); preview.Position=UDim2.new(0,46,0,42); preview.BackgroundColor3=Color3.fromRGB(9,9,11); preview.BackgroundTransparency=0.15; preview.BorderSizePixel=0; preview.Image=TITLE_IMAGE_ASSETS[math.clamp(tonumber(titleIndex) or 1,1,#TITLE_IMAGE_ASSETS)]; preview.ImageColor3=SnowGetUiThemeColor(); preview.ScaleType=Enum.ScaleType.Fit; guiCorner(preview,7); guiStroke(preview,Color3.fromRGB(70,130,150),1).Transparency=0.3
    local cards={}
    local function selectTitle(index)
        titleIndex=index
        if GuiRefs.snowTitle and (GuiRefs.snowTitle:IsA("ImageLabel") or GuiRefs.snowTitle:IsA("ImageButton")) then GuiRefs.snowTitle.Image=TITLE_IMAGE_ASSETS[index] end
        if GuiRefs.reopenTitle and (GuiRefs.reopenTitle:IsA("ImageLabel") or GuiRefs.reopenTitle:IsA("ImageButton")) then GuiRefs.reopenTitle.Image=TITLE_IMAGE_ASSETS[index] end
        preview.Image=TITLE_IMAGE_ASSETS[index]
        for i,card in ipairs(cards) do
            local stroke=card:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color=(i==index) and C.blue or Color3.fromRGB(70,130,150); stroke.Thickness=(i==index) and 1.8 or 1 end
        end
        saveConfig()
    end
    for i,asset in ipairs(TITLE_IMAGE_ASSETS) do
        local card=Instance.new("ImageButton",selector); card.Visible=false; card.Size=UDim2.new(0,0,0,0); card.BackgroundTransparency=1; card.BorderSizePixel=0; card.AutoButtonColor=false; card.Image=asset; card.ScaleType=Enum.ScaleType.Fit
        guiCorner(card,7); local stroke=guiStroke(card,(i==titleIndex) and C.blue or Color3.fromRGB(70,130,150),(i==titleIndex) and 1.8 or 1); stroke.Transparency=(i==titleIndex) and 0 or 0.55
        card.MouseButton1Click:Connect(function() selectTitle(i) end)
        table.insert(cards,card)
    end
    prev.MouseButton1Click:Connect(function() selectTitle((titleIndex-2)%#TITLE_IMAGE_ASSETS+1) end)
    next.MouseButton1Click:Connect(function() selectTitle(titleIndex%#TITLE_IMAGE_ASSETS+1) end)
end)()

-- Azure tabs are deliberately isolated from the white theme.  This repaint
-- owns every visual property of the tab buttons while AZZURRO is selected.
SnowApplyAzureTabs=function()
    if snowUiThemeName~="AZZURRO" or not (CategoryRefs and CategoryRefs.btnsSide) then return end
    for name,tab in pairs(CategoryRefs.btnsSide) do
        if tab and tab.Parent then
            local selected=(CategoryRefs.active==name)
            tab.BackgroundColor3=Color3.fromRGB(0,0,0)
            tab.BackgroundTransparency=.38
            tab.TextColor3=Color3.fromRGB(255,255,255)
            tab.TextTransparency=0
            local label=tab:FindFirstChild("TabLabel")
            if label then
                -- This is the visible tab caption.  Keep it independent of
                -- the selected/inactive tab animation and fully readable.
                label.TextColor3=Color3.fromRGB(255,255,255)
                label.TextTransparency=0
                label.TextStrokeColor3=Color3.fromRGB(0,0,0)
                label.TextStrokeTransparency=0
                label.Font=Enum.Font.GothamBold
                label.ZIndex=10
                label.BackgroundTransparency=1
            end
            local stroke=tab:FindFirstChild("TabStroke")
            if stroke then
                stroke.Color=selected and Color3.fromRGB(80,215,255) or Color3.fromRGB(72,118,135)
                stroke.Transparency=selected and 0 or .48
                stroke.Thickness=1
            end
            local border=tab:FindFirstChild("TabBorder")
            if border then
                border.BackgroundTransparency=1
                local outline=border:FindFirstChild("SelectionStroke")
                if outline then outline.Color=Color3.fromRGB(80,215,255); outline.Transparency=selected and 0 or 1; outline.Thickness=selected and 2 or 1 end
            end
        end
    end
end
SnowApplyWhiteTabs=function()
    if snowUiThemeName~="BIANCO" or not (CategoryRefs and CategoryRefs.btnsSide) then return end
    for name,tab in pairs(CategoryRefs.btnsSide) do
        if tab and tab.Parent then
            local selected=(CategoryRefs.active==name)
            tab.BackgroundColor3=Color3.fromRGB(0,0,0)
            tab.BackgroundTransparency=.38
            tab.TextColor3=Color3.fromRGB(255,255,255)
            tab.TextTransparency=0
            local label=tab:FindFirstChild("TabLabel")
            if label then
                -- The label, not the TextButton itself, is what the player
                -- sees.  It must stay pure white for every white-theme tab.
                label.TextColor3=Color3.fromRGB(255,255,255)
                label.TextTransparency=0
                label.TextStrokeColor3=Color3.fromRGB(0,0,0)
                label.TextStrokeTransparency=0
                label.Font=Enum.Font.GothamBold
                label.ZIndex=10
                label.BackgroundTransparency=1
            end
            local stroke=tab:FindFirstChild("TabStroke")
            if stroke then stroke.Color=selected and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,82,91); stroke.Transparency=0; stroke.Thickness=1 end
            local border=tab:FindFirstChild("TabBorder")
            local outline=border and border:FindFirstChild("SelectionStroke")
            if outline then outline.Color=Color3.fromRGB(255,255,255); outline.Transparency=selected and 0 or 1; outline.Thickness=selected and 2 or 1 end
        end
    end
end
local snowAzureTabLast=0
RunService.Heartbeat:Connect(function()
    if os.clock()-snowAzureTabLast>.12 then
        snowAzureTabLast=os.clock()
        if snowUiThemeName=="AZZURRO" then SnowApplyAzureTabs() elseif snowUiThemeName=="BIANCO" then SnowApplyWhiteTabs() end
    end
end)

-- KEYBINDS PAGE (dual PC/Gamepad bind button)
;(function()
    local kb=CategoryRefs.contents["Keybind"]
    -- Keybinds now live next to the controls they operate; the STEAL tab is
    -- reserved for Auto Steal only.
    if true then return end
    local GAMEPAD_KEYS={
        [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
        [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
        [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
        [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,
    }
    local function isGamepadInput(inp)
        return inp and inp.UserInputType and tostring(inp.UserInputType.Name):match("^Gamepad")~=nil
    end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function formatKeybindText(entry)
        if not entry then return "None" end
        local key=entry.kb or entry.gp
        return key and key.Name or "None"
    end
    local _anyKeyListening=false; local kbButtons={}
    local function mkKBRow(parent, txt, kbEntry, order)
        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,38)
        row.BackgroundColor3=C.row
        row.BackgroundTransparency=0.5
        row.BorderSizePixel=0
        row.LayoutOrder=order or 0
        guiCorner(row,10); guiStroke(row,C.divider,1)
        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(1,-110,1,0); lbl.Position=UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=txt
        lbl.TextColor3=C.text; lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        local function getLabel() return formatKeybindText(kbEntry) end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,96,0,24); btn.Position=UDim2.new(1,-104,0.5,-12)
        btn.BackgroundColor3=Color3.fromRGB(5,7,10); btn.BackgroundTransparency=0.28
        btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.ZIndex=5
        btn.Text=getLabel(); btn.TextColor3=Color3.fromRGB(255,255,255); btn.TextSize=10
        btn.Font=Enum.Font.GothamMedium; btn.TextTruncate=Enum.TextTruncate.AtEnd
        guiCorner(btn,6); guiStroke(btn,Color3.fromRGB(75,80,88),1).Transparency=0.48
        kbButtons[kbEntry]=btn
        local listening=false; local conn=nil; local listenStart=0
        btn.MouseButton1Click:Connect(function()
            if listening then
                listening=false; _anyKeyListening=false
                if conn then conn:Disconnect(); conn=nil end
                btn.Text=getLabel(); btn.TextColor3=C.white
                return
            end
            listening=true; _anyKeyListening=true; listenStart=tick()
            btn.Text="Press key..."; btn.TextColor3=C.white
            conn=UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.KeyCode==Enum.KeyCode.Escape then
                    listening=false; _anyKeyListening=false
                    if conn then conn:Disconnect(); conn=nil end
                    btn.Text=getLabel(); btn.TextColor3=C.white
                    return
                end
                local isGp=isGamepadInput(inp)
                if isGp and (tick()-listenStart)<0.15 then return end
                if inp.KeyCode==Enum.KeyCode.Backspace or inp.KeyCode==Enum.KeyCode.Delete then
                    kbEntry.kb=nil; kbEntry.gp=nil
                    if txt=="Carry Speed" then Keys.carryMode=nil end
                    listening=false; _anyKeyListening=false
                    if conn then conn:Disconnect(); conn=nil end
                    btn.Text=getLabel(); btn.TextColor3=C.white; pcall(saveConfig)
                    return
                end
                if not isBindableInput(inp) then return end
                for _,other in pairs(KB) do
                    if other~=kbEntry and type(other)=="table" then
                        if isGp and other.gp==inp.KeyCode then other.gp=nil end
                        if not isGp and other.kb==inp.KeyCode then other.kb=nil end
                        local otherBtn=kbButtons[other]
                        if otherBtn then otherBtn.Text=formatKeybindText(other) end
                    end
                end
                if isGp then kbEntry.kb=nil; kbEntry.gp=inp.KeyCode else kbEntry.gp=nil; kbEntry.kb=inp.KeyCode end
                -- mirror into Keys for legacy handler
                if txt=="Hide GUI" then Keys.guiHide=kbEntry.kb or Keys.guiHide end
                if txt=="Carry Speed" then Keys.carryMode=kbEntry.kb end
                if txt=="Lagger Mode" then Keys.laggerToggle=kbEntry.kb or Keys.laggerToggle end
                if txt=="Lagger Carry" then Keys.laggerCarry=kbEntry.kb or Keys.laggerCarry end
                if txt=="Bat Aimbot" then Keys.circle=kbEntry.kb or Keys.circle end
                if txt=="TP Bat" then Keys.tpBat=kbEntry.kb or Keys.tpBat end
                if txt=="Auto Left" then Keys.autoLeft=kbEntry.kb or Keys.autoLeft end
                if txt=="Auto Right" then Keys.autoRight=kbEntry.kb or Keys.autoRight end
                if txt=="Drop Brainrot" then Keys.dropBrainrot=kbEntry.kb or Keys.dropBrainrot end
                if txt=="TP Down" then Keys.tpDown=kbEntry.kb or Keys.tpDown end
                listening=false; _anyKeyListening=false
                if conn then conn:Disconnect(); conn=nil end
                btn.Text=getLabel(); btn.TextColor3=C.white
                pcall(saveConfig)
            end)
        end)
        local hov=Instance.new("TextButton",row)
        hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function() tw(row,{BackgroundTransparency=0.3}) end)
        hov.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.5}) end)
        return row
    end

    addSectLbl(kb,"Keybinds (PC + Gamepad)",0)
    mkKBRow(kb,"Hide GUI",KB.GuiHide,1)
    mkKBRow(kb,"Normal Key (Normal Speed)",KB.SpeedToggle,2)
    mkKBRow(kb,"Lagger Key (Lagger Speed)",KB.LaggerToggle,3)
    mkKBRow(kb,"Bat Aimbot",KB.AutoBat,4)
    mkKBRow(kb,"TP Bat",KB.TPBat,5)
    mkKBRow(kb,"Auto Left",KB.AutoLeft,6)
    mkKBRow(kb,"Auto Right",KB.AutoRight,7)
    mkKBRow(kb,"Drop Brainrot",KB.DropBrainrot,8)
    mkKBRow(kb,"TP Down",KB.TPFloor,9)
    mkKBRow(kb,"Insta Reset",KB.InstaReset,10)
end)()

-- KEYBOARD + CONTROLLER SHORTCUTS (K7 dual-bind aware)
function kbMatch(entry, kc)
    if not kc or kc==Enum.KeyCode.Unknown then return false end
    if not entry or type(entry)~="table" then return false end
    if entry.kb and kc==entry.kb then return true end
    if entry.gp and kc==entry.gp then return true end
    return false
end
function isBoundKey(k)
    if not k or k==Enum.KeyCode.Unknown then return false end
    for _,entry in pairs(KB) do
        if type(entry)=="table" and (entry.kb==k or entry.gp==k) then return true end
    end
    for _,bk in pairs(Keys) do
        if bk==k then return true end
    end
    return false
end
_bindLast = {}
function bindReady(name)
    local t = tick()
    if (_bindLast[name] or 0) + 0.25 > t then return false end
    _bindLast[name] = t
    return true
end
UIS.InputBegan:Connect(function(inp,gp)
    if UIS:GetFocusedTextBox() then return end
    local k = inp.KeyCode
    if k==Enum.KeyCode.Unknown then return end
    if k==Enum.KeyCode.Thumbstick1 or k==Enum.KeyCode.Thumbstick2 then return end
    -- tools mark R1/L1 as gameProcessed — still fire our custom binds
    if gp and not isBoundKey(k) then return end
    -- Hide GUI must use its live binding only.  Keys.guiHide is a legacy
    -- mirror which can keep an old key after the user changes the binding.
    if kbMatch(KB.GuiHide,k) then
        if not bindReady("guiHide") then return end
        if GuiRefs.outer and GuiRefs.outer.Visible then
            if GuiRefs.hideGui then GuiRefs.hideGui() else GuiRefs.outer.Visible=false end
        else
            if GuiRefs.showGui then GuiRefs.showGui() elseif GuiRefs.outer then GuiRefs.outer.Visible=true end
        end
    elseif kbMatch(KB.SpeedToggle,k) then toggleCarryMode(); saveConfig()
    elseif kbMatch(KB.LaggerToggle,k) then if not bindReady("laggerToggle") then return end; toggleLaggerMode(); saveConfig()
    elseif kbMatch(KB.LaggerCarry,k) then if not bindReady("laggerCarry") then return end; toggleLaggerCarry(); saveConfig()
    elseif kbMatch(KB.AutoBat,k) then
        local running=(aimbotMode=="BYPASS") and (batV2Enabled or Dragon.batV2) or autoBatEnabled
        if running then stopBatAimbot() elseif aimbotMode=="BYPASS" then Dragon.startBatV2() else startBatAimbot() end
        saveConfig()
    elseif kbMatch(KB.DropBrainrot,k) then runDrop()
    elseif kbMatch(KB.InstaReset,k) then runInstaReset()
    elseif kbMatch(KB.TPFloor,k) then runTPFloor()
    elseif kbMatch(KB.TPBat,k) then
        if Dragon.tpBat then
            Dragon.stopTPBat()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                Dragon.startTPBat()
            end
        end
        if Dragon.setTPBatVisual then Dragon.setTPBatVisual(Dragon.tpBat) end
        if mobBtnRefs.tpBat then mobBtnRefs.tpBat(Dragon.tpBat) end
        saveConfig()
    elseif autoPlayMode and kbMatch(KB.AutoPlay,k) then
        Dragon.setAutoPlay(not autoPlayEnabled)
        if autoPlaySet then autoPlaySet(autoPlayEnabled) end
        saveConfig()
    elseif (not autoPlayMode) and kbMatch(KB.AutoLeft,k) then
        if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoLeftEnabled=true; startAutoLeft()
            end
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        saveConfig()
    elseif (not autoPlayMode) and kbMatch(KB.AutoRight,k) then
        if autoRightEnabled then autoRightEnabled=false; stopAutoRight()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoRightEnabled=true; startAutoRight()
            end
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        saveConfig()
    end
end)

-- STARTUP
if infJumpEnabled then setInfJumpInternal(true) end
if batSoundsEnabled then task.defer(function() setSnowBatSounds(true) end) end
task.defer(function() applySnowMedusaSkin(medusaSkinMode) end)
if medusaSoundsEnabled then task.defer(function() setSnowMedusaSounds(true) end) end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if espEnabled then startESP() end
if enemySpeedEnabled then startEnemySpeedESP() end
if Dragon.enemyRagdollTimerEnabled then Dragon.startEnemyRagdollTimer() end
refreshSnowExtraESP()
-- Capture the completed original (azure) GUI once. Every later theme switch
-- restores this snapshot first, so the two modes never contaminate each other.
SnowCaptureBaseUi()
if snowUiThemeName=="BIANCO" or snowUiThemeName=="AZZURRO" then SnowApplyUiTheme(snowUiThemeName,false) else SnowApplyFullColorTheme(snowUiThemeName,false) end
-- Arrow and step controls stay as clean symbols: no grey square behind them.
task.defer(function()
    local hub=GuiRefs and GuiRefs.hub
    if not hub then return end
    local symbols={ ["+"]=true, ["−"]=true, ["▲"]=true, ["▼"]=true, ["‹"]=true, ["›"]=true }
    for _,button in ipairs(hub:GetDescendants()) do
        if button:IsA("TextButton") and symbols[button.Text] and button.Name~="ThemeCloseButton" then
            button.BackgroundTransparency=1
            local stroke=button:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency=1 end
        end
    end
end)
createDragonOverhead(LP.Character)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.25)
    createDragonOverhead(char)
end)
if Dragon.antiKick then Dragon.enableAntiKick() end
SnowApplySkyTheme(SnowCurrentSkyTheme)
dragonAfterIntro(buildMobileButtons)

-- ============================================================
-- IDLE UI FADE (inside GUI scope) — Inner chrome fades after 5s
-- ============================================================
do
    local IDLE_SEC = 2.5
    local lastInteract = tick()
    local faded = false
    local tiIn = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tiOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- CanvasGroup wraps tabs + content for clean GroupTransparency fade
    local chromeGroup = Instance.new("CanvasGroup")
    chromeGroup.Name = "ChromeFade"
    chromeGroup.Size = UDim2.new(1, 0, 1, 0)
    chromeGroup.Position = UDim2.new(0, 0, 0, 0)
    chromeGroup.BackgroundTransparency = 1
    chromeGroup.BorderSizePixel = 0
    chromeGroup.GroupTransparency = 0
    chromeGroup.ZIndex = 2
    chromeGroup.Parent = GuiRefs.inner

    -- Re-parent header / tabs / content / seps into chrome group (bg stays on Inner)
    local inner = GuiRefs.inner
    local moveNames = {
        TabBar = true,
        ContentFrame = true,
    }
    if inner then
        local toMove = {}
        for _, ch in ipairs(inner:GetChildren()) do
            if moveNames[ch.Name] then
                table.insert(toMove, ch)
            elseif ch:IsA("Frame") and ch.Size.Y.Offset == 1 then
                table.insert(toMove, ch)
            end
        end
        for _, ch in ipairs(toMove) do
            ch.Parent = chromeGroup
        end
    end
    GuiRefs.chromeGroup = chromeGroup

    -- Title image stays outside Inner fade (never gets GroupTransparency)
    pcall(function()
        local title = GuiRefs.snowTitle
        local outer = GuiRefs.outer
        if title and outer then
            title.Parent = outer
            title.ZIndex = 50
            title.AnchorPoint = Vector2.new(0, 0)
            title.Position = UDim2.new(0, 96, 0, 18)
            title.Size = UDim2.new(0, 202, 0, 34)
            title.BackgroundTransparency = 1
            -- keep title locked to outer top while menu moves
            if not title:GetAttribute("SnowTitlePinned") then
                title:SetAttribute("SnowTitlePinned", true)
                outer:GetPropertyChangedSignal("Position"):Connect(function()
                    -- follows parent Outer automatically
                end)
            end
        end
        -- also remove any title left inside header/chrome
        local function stripTitle(root)
            if not root then return end
            for _,d in ipairs(root:GetDescendants()) do
                if d.Name == "SnowTitle" and d ~= GuiRefs.snowTitle then
                    pcall(function() d:Destroy() end)
                end
            end
        end
        stripTitle(chromeGroup)
        stripTitle(GuiRefs.inner)
    end)

    local function bump()
        lastInteract = tick()
    end

    local function fadeToIdle()
        if faded then return end
        faded = true
        TweenService:Create(chromeGroup, tiIn, {GroupTransparency = 0.88}):Play()
        -- title image never fades with inner
        pcall(function()
            if GuiRefs.snowTitle then
                if GuiRefs.snowTitle:IsA("ImageLabel") or GuiRefs.snowTitle:IsA("ImageButton") then
                    GuiRefs.snowTitle.ImageTransparency = 0
                end
                GuiRefs.snowTitle.BackgroundTransparency = 1
            end
        end)
        -- Only the controls fade.  Keep the panel/background at its normal
        -- opacity so Auto Fade never makes the artwork look washed out.
        if GuiRefs.inner then GuiRefs.inner.BackgroundTransparency=0 end
    end

    local function restoreUI()
        bump()
        if not faded then return end
        faded = false
        TweenService:Create(chromeGroup, tiOut, {GroupTransparency = 0}):Play()
        if GuiRefs.inner then
            pcall(function()
                TweenService:Create(GuiRefs.inner, tiOut, {BackgroundTransparency = 0}):Play()
            end)
        end
    end
    -- Theme changes are an interaction too.  Expose this to the selector so
    -- a switch can never leave the tabs/content in an idle-faded state.
    SnowWakeUi=function()
        restoreUI()
        if chromeGroup then chromeGroup.GroupTransparency=0 end
        if GuiRefs.inner then GuiRefs.inner.BackgroundTransparency=0 end
    end

    local function onPress(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
            or inp.UserInputType == Enum.UserInputType.MouseButton2 then
            restoreUI()
        end
    end

    local outer = GuiRefs.outer
    if outer then
        outer.Active = true
        outer.InputBegan:Connect(onPress)
    end
    if chromeGroup then
        chromeGroup.InputBegan:Connect(onPress)
    end
    if GuiRefs.contentFrame then
        GuiRefs.contentFrame.InputBegan:Connect(onPress)
    end
    if GuiRefs.categoryList then
        GuiRefs.categoryList.InputBegan:Connect(onPress)
    end
    -- Scrolling is interaction too: do not fade the UI while the user is
    -- moving through a tab, including touch/mouse-wheel scrolling.
    pcall(function()
        for _,d in ipairs(chromeGroup:GetDescendants()) do
            if d:IsA("ScrollingFrame") then
                d:GetPropertyChangedSignal("CanvasPosition"):Connect(restoreUI)
                d.InputChanged:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseWheel
                        or input.UserInputType==Enum.UserInputType.Touch then
                        restoreUI()
                    end
                end)
            end
        end
    end)
    -- buttons reset timer
    pcall(function()
        for _, d in ipairs(chromeGroup:GetDescendants()) do
            if d:IsA("TextButton") or d:IsA("ImageButton") then
                d.MouseButton1Click:Connect(function() restoreUI() end)
                d.InputBegan:Connect(onPress)
            end
        end
    end)

    task.spawn(function()
        while outer and outer.Parent do
            if outer.Visible then
                if uiAutoFadeEnabled and not faded and (tick() - lastInteract) >= IDLE_SEC then
                    fadeToIdle()
                end
            else
                if faded then
                    faded = false
                    pcall(function() chromeGroup.GroupTransparency = 0 end)
                end
                bump()
            end
            task.wait(0.12)
        end
    end)
end

end)()



-- E01 alert: a top-screen steal safety bar, using the source detector logic
-- without placing UI above the avatar's head.
;(function()
    local gui=Instance.new("ScreenGui")
    gui.Name="Dragon_E01Alert"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=1000000; gui.ZIndexBehavior=Enum.ZIndexBehavior.Global
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end
    -- Aura-style E01 bar.  The progress itself stays white, as requested.
    local bar=Instance.new("Frame",gui); bar.AnchorPoint=Vector2.new(.5,0); bar.Position=UDim2.new(.5,0,0,18); bar.Size=UDim2.new(0,300,0,36); bar.BackgroundColor3=Color3.fromRGB(0,0,0); bar.BackgroundTransparency=.34; bar.BorderSizePixel=0; bar.Visible=false; bar.ZIndex=100
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
    local pillStroke=Instance.new("UIStroke",bar); pillStroke.Color=Color3.fromRGB(255,255,255); pillStroke.Thickness=1.1; pillStroke.Transparency=1
    local track=Instance.new("Frame",bar); track.Position=UDim2.new(0,3,0,3); track.Size=UDim2.new(1,-6,1,-6); track.BackgroundColor3=Color3.fromRGB(0,0,0); track.BackgroundTransparency=.48; track.BorderSizePixel=0; track.ClipsDescendants=true; track.ZIndex=101; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",track); fill.Name="E01Fill"; fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=Color3.fromRGB(255,255,255); fill.BackgroundTransparency=.24; fill.BorderSizePixel=0; fill.ZIndex=102; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local fillGradient=Instance.new("UIGradient",fill); fillGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(165,165,165)),ColorSequenceKeypoint.new(.55,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(190,190,190))}); fillGradient.Rotation=0
    local text=Instance.new("TextLabel",bar); text.Size=UDim2.new(1,-16,1,0); text.Position=UDim2.new(0,8,0,0); text.BackgroundTransparency=1; text.Font=Enum.Font.GothamBlack; text.TextSize=14; text.Text="DONT STEAL"; text.TextColor3=Color3.fromRGB(255,82,92); text.TextStrokeTransparency=.18; text.TextStrokeColor3=Color3.fromRGB(0,0,0); text.TextXAlignment=Enum.TextXAlignment.Center; text.ZIndex=104
    local carrying=false; local started=0; local armed=false; local completed=false; local completedAt=0
    local alertShown=false; local alertExiting=false
    local previewUntil=0
    local function applyE01Size()
        local scale=math.clamp(tonumber(e01AlertScale) or 1,.7,1.4)
        bar.Size=UDim2.new(0,math.floor(300*scale+.5),0,math.floor(36*scale+.5))
        text.TextSize=math.max(10,math.floor(14*scale+.5))
    end
    Dragon.previewE01Alert=function(seconds)
        applyE01Size(); previewUntil=tick()+(seconds or 2); alertShown=true; alertExiting=false
        bar.Visible=true; bar.Position=UDim2.new(.5,0,0,18); fill.Size=UDim2.new(.55,0,1,0); text.Text="DONT STEAL"; text.TextColor3=Color3.fromRGB(255,82,92)
    end
    applyE01Size()
    local function hideE01Animated()
        if not bar.Visible or alertExiting then return end
        alertExiting=true; alertShown=false
        TweenService:Create(bar,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position=UDim2.new(.5,bar.Position.X.Offset,0,-82)}):Play()
        task.delay(.3,function()
            if alertExiting and bar and bar.Parent then bar.Visible=false; alertExiting=false end
        end)
    end
    local function isCarrying()
        local char=LP.Character; if not char then return false end
        for _,child in ipairs(char:GetChildren()) do
            local n=child.Name:lower()
            if n:find("brain",1,true) or n:find("animal",1,true) or n:find("carry",1,true) or n:find("steal",1,true) or n:find("held",1,true) then return true end
        end
        for name,value in pairs(char:GetAttributes()) do
            local n=tostring(name):lower()
            if value==true and (n:find("carry",1,true) or n:find("steal",1,true) or n:find("brain",1,true)) then return true end
        end
        -- Same fallback used by the provided E01 logic: carrying states in
        -- this game often expose themselves only as a reduced WalkSpeed.
        local hum=char:FindFirstChildOfClass("Humanoid")
        return hum~=nil and hum.WalkSpeed>0 and hum.WalkSpeed<=25 and hum.WalkSpeed~=16
    end
    RunService.RenderStepped:Connect(function()
        if not snowVisualUpdateDue("e01Alert",0.08) then return end
        if tick()<previewUntil then
            bar.Visible=true; Dragon.alertLayout.e01Visible=true
            return
        end
        if not e01AlertEnabled then
            bar.Visible=false; alertShown=false; alertExiting=false; Dragon.alertLayout.e01Visible=false; carrying=false; armed=false; completed=false
            local ping=Dragon.alertLayout.pingBanner
            if ping and ping.Parent and ping.Visible then ping.Position=UDim2.new(.5,-130,0,8) end
            return
        end
        local nowCarrying=isCarrying()
        -- The warning only belongs on screen while the brainrot is actually
        -- being carried; do not leave it up after it has been dropped.
        if not nowCarrying then
            carrying=false; armed=false; completed=false; bar.Visible=false; alertShown=false; alertExiting=false; Dragon.alertLayout.e01Visible=false; fill.Size=UDim2.new(0,0,1,0)
            local ping=Dragon.alertLayout.pingBanner
            if ping and ping.Parent and ping.Visible then ping.Position=UDim2.new(.5,-130,0,8) end
            return
        end
        if nowCarrying and not carrying then started=tick(); armed=true; completed=false end
        carrying=nowCarrying
        if not armed then bar.Visible=false; return end
        if completed then
            if tick()-completedAt>=1.5 then
                hideE01Animated(); Dragon.alertLayout.e01Visible=false; armed=false
            else
                bar.Visible=true; Dragon.alertLayout.e01Visible=true
            end
            return
        end
        local progress=math.clamp((tick()-started)/2.6,0,1)
        bar.Visible=true; Dragon.alertLayout.e01Visible=true; fill.Size=UDim2.new(progress,0,1,0)
        local ping=Dragon.alertLayout.pingBanner
        local targetPosition
        if Dragon.alertLayout.pingVisible and ping and ping.Parent and ping.Visible then
            ping.Position=UDim2.new(.5,-285,0,8)
            targetPosition=UDim2.new(.5,135,0,18)
        else
            targetPosition=UDim2.new(.5,0,0,18)
        end
        if not alertShown then
            alertShown=true; alertExiting=false
            bar.Position=UDim2.new(.5,targetPosition.X.Offset,0,100)
            TweenService:Create(bar,TweenInfo.new(.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=targetPosition}):Play()
        elseif not alertExiting then
            bar.Position=targetPosition
        end
        if progress>=1 then
            text.Text="STEAL"; text.TextColor3=Color3.fromRGB(24,206,98)
            completed=true; completedAt=tick()
        else
            text.Text="DONT STEAL"; text.TextColor3=Color3.fromRGB(255,82,92)
        end
    end)
end)()