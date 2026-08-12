local u1 = {
    Cor_Hub = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(15, 15, 15),
    Cor_Stroke = Color3.fromRGB(60, 60, 60),
    Cor_Text = Color3.fromRGB(240, 240, 240),
    Cor_DarkText = Color3.fromRGB(140, 140, 140),
    Corner_Radius = UDim.new(0, 4),
    Text_Font = Enum.Font.FredokaOne,
}
local u2 = {}
local u3 = getcustomasset or (getsynasset or getkrnlasset)

function validateAndConvertMP3(p4, p5)
    if u2[p5] then
        return u2[p5]
    end

    local v6 = game:HttpGet(p4)

    if isfile(p5) then
        if readfile(p5) ~= v6 then
            writefile(p5, v6)
        end
    else
        writefile(p5, v6)
    end

    local u7 = u3(p5)

    if pcall(function()
        local _Sound = Instance.new('Sound')

        _Sound.SoundId = u7
        _Sound.Volume = 0
        _Sound.Parent = workspace

        _Sound:Play()

        repeat
            task.wait()
        until _Sound.IsLoaded or not _Sound.IsPlaying

        _Sound:Stop()
        _Sound:Destroy()
    end) then
        u2[p5] = u7

        if isfile(p5) then
            delfile(p5)
        end
    end

    return u7
end

songsmp3 = {
    {
        name = "Que Historia Les Cuento",
        id = "https://files.catbox.moe/51vid2.mp3", 
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "Tuff Song",
        id = "https://files.catbox.moe/rvf2vy.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "Orula",
        id = "https://files.catbox.moe/v20ko9.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "LAJA",
        id = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "Beretta",
        id = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "X.O.X.O",
        id = "https://files.catbox.moe/jghp0f.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "To The O",
        id = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "HORA 0",
        id = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "Lucid Dreams",
        id = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "El corrido del 30",
        id = "https://files.catbox.moe/pf9kd9.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "WARE",
        id = "https://files.catbox.moe/p2pp91.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "El Hijo del 7",
        id = "https://files.catbox.moe/wpbab3.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "WOW",
        id = "https://files.catbox.moe/14rdtj.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "el de la R",
        id = "https://files.catbox.moe/u67vx5.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "EL CHIRICUAZO",
        id = "https://files.catbox.moe/va3lhi.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "El Maestro",
        id = "https://files.catbox.moe/bmjsah.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "Seteadora",
        id = "https://files.catbox.moe/94olvv.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    },
    {
        name = "El Ondeado V2",
        id = "https://files.catbox.moe/4lqp91.mp3",
        imageId = "rbxthumb://type=Asset&id=93917932838439&w=150&h=150"
    }
}
    
    


    

local u9 = 1

-- Guarda las preferencias del reproductor entre ejecuciones del script.
local _HttpService = game:GetService('HttpService')
local _MusicStateFile = 'MusicUI_MP3_DANHUB_config.json'
local _SavedMusicState = {}

if isfile(_MusicStateFile) then
    local vSavedStateOk, vSavedState = pcall(function()
        return _HttpService:JSONDecode(readfile(_MusicStateFile))
    end)

    if vSavedStateOk and type(vSavedState) == 'table' then
        _SavedMusicState = vSavedState
    end
end

local function getSavedMusicNumber(pSavedKey, pDefaultValue, pMinimum, pMaximum)
    local vSavedValue = tonumber(_SavedMusicState[pSavedKey])

    if vSavedValue == nil then
        return pDefaultValue
    end

    return math.clamp(vSavedValue, pMinimum, pMaximum)
end

u9 = math.floor(getSavedMusicNumber('songIndex', u9, 1, #songsmp3))
local _SavedTimePosition = getSavedMusicNumber('timePosition', 0, 0, 1000000000)
local _SavedVolume = getSavedMusicNumber('volume', 0.7, 0, 2.5)

game:GetService('CoreGui')

local _UserInputService = game:GetService('UserInputService')
local _RunService = game:GetService('RunService')
local _TweenService = game:GetService('TweenService')

functionCreate1 = {}

function functionCreate1.Create(p13, p14, p15)
    local u16 = Instance.new(p13, p14)

    if p15 then
        table.foreach(p15, function(p17, p18)
            u16[p17] = p18
        end)
    end

    local u19 = nil

    u19 = u16.AncestryChanged:Connect(function()
        if not u16.Parent then
            u16:Destroy()

            if u19 then
                u19:Disconnect()

                u19 = nil
            end
        end
    end)

    return u16
end

Create = functionCreate1.Create

function functionCreate1.SetProps(p20, p21)
    if p20 and p21 then
        table.foreach(p21, function(p22, p23)
            p20[p22] = p23
        end)
    end

    return p20
end
function functionCreate1.Corner(p24, p25)
    local _UICorner = Create('UICorner', p24)

    _UICorner.CornerRadius = u1.Corner_Radius

    if p25 then
        functionCreate1.SetProps(_UICorner, p25)
    end

    return _UICorner
end
function functionCreate1.Stroke(p27, p28)
    local _UIStroke = Create('UIStroke', p27)

    _UIStroke.Color = u1.Cor_Stroke

    if p28 and p28.Color then
        _UIStroke.Color = p28.Color
    end

    _UIStroke.ApplyStrokeMode = 'Border'

    if p28 then
        functionCreate1.SetProps(_UIStroke, p28)
    end

    return _UIStroke
end
function functionCreate1.CreateGradient(p30, p31)
    local _UIGradient = Instance.new('UIGradient')

    _UIGradient.Parent = p30

    local v33 = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(127, 127, 127),
        Color3.fromRGB(0, 0, 0),
    }

    if p31 and p31.Color then
        local _Color = p31.Color
        local v35 = math.min(#_Color, 3)
        local v36 = {}

        for v37 = 1, v35 do
            local v38 = (v37 - 1) / (v35 - 1)

            table.insert(v36, ColorSequenceKeypoint.new(v38, _Color[v37]))
        end

        _UIGradient.Color = ColorSequence.new(v36)
    else
        _UIGradient.Color = ColorSequence.new(v33[1], v33[2], v33[3])
    end
    if p31 and p31.Rotation then
        _UIGradient.Rotation = p31.Rotation
    end
    if p31 and p31.Intensity then
        local _Value = _UIGradient.Color.Keypoints[1].Value
        local _Value2 = _UIGradient.Color.Keypoints[#_UIGradient.Color.Keypoints].Value
        local v41 = _Value:Lerp(Color3.fromRGB(0, 0, 0), p31.Intensity)
        local v42 = _Value2:Lerp(Color3.fromRGB(0, 0, 0), p31.Intensity)

        _UIGradient.Color = ColorSequence.new(v41, v42)
    end
    if p31 and p31.Offset then
        _UIGradient.Offset = p31.Offset
    end
    if p31 and p31.Tween then
        local v43 = p31.Speed or 2
        local v44 = {
            Rotation = _UIGradient.Rotation + 360,
        }

        _TweenService:Create(_UIGradient, TweenInfo.new(v43, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), v44):Play()
    end

    return _UIGradient
end
function functionCreate1.CreateTween(p45, p46, p47, p48, p49)
    local v50 = _TweenService:Create(p45, TweenInfo.new(p48, Enum.EasingStyle.Linear), {[p46] = p47})

    v50:Play()

    if p49 then
        v50.Completed:Wait()
    end
end
function functionCreate1.TextSetColor(p51)
    if p51 and p51.Parent then
        local u52 = {}
        local u53 = false

        u52.MouseEnter = p51.MouseEnter:Connect(function()
            u53 = true
        end)
        u52.MouseLeave = p51.MouseLeave:Connect(function()
            u53 = false
        end)
        u52.RenderStepped = _RunService.RenderStepped:Connect(function()
            if u53 then
                CreateTween56(p51, 'TextColor3', Color3.fromRGB(30, 140, 200), 0.4, true)
            else
                CreateTween56(p51, 'TextColor3', u1.Cor_Text, 0.4, false)
            end
        end)

        local function u58()
            local v54, v55, v56 = pairs(u52)

            while true do
                local v57

                v56, v57 = v54(v55, v56)

                if v56 == nil then
                    break
                end
                if v57 then
                    v57:Disconnect()
                end
            end

            u52 = {}
        end

        u52.AncestryChanged = p51.AncestryChanged:Connect(function(_, p59)
            if p59 == nil and p51.Parent == nil then
                u58()
            end
        end)
    end
end

SetProps1 = functionCreate1.SetProps
Corner1 = functionCreate1.Corner
Stroke1 = functionCreate1.Stroke
CreateGradient1 = functionCreate1.CreateGradient
CreateTween56 = functionCreate1.CreateTween
TextSetColor1 = functionCreate1.TextSetColor

function AddSlider56(p60, p61)
    local v62 = p61.Name or (p61.Title or 'Slider!')
    local _ = p61.Description
    local v63 = p61.MinValue or (p61.Min or 10)
    local v64 = p61.MaxValue or (p61.Max or 100)
    local u65 = p61.Increase or 1
    local u66 = p61.Default or 25
    local u67 = p61.Callback or function() end
    local u68 = {}
    local v69 = v63 / u65
    local u70 = v64 / u65
    local u71 = v69
    local _Frame = Create('Frame', p60, {
        Size = UDim2.new(0.95, 0, 0.1, 0),
        BackgroundColor3 = u1 and u1.Cor_Options or Color3.new(0.2, 0.2, 0.2),
        Name = 'SliderFrame',
    })

    Corner1(_Frame)
    Stroke1(_Frame)

    local _TextLabel = Create('TextLabel', _Frame, {
        Text = v62,
        Size = UDim2.new(0.615, 0, 1, 0),
        Position = UDim2.new(0.385, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = u1 and u1.Text_Font or Enum.Font.SourceSans,
        TextColor3 = u1 and u1.Cor_Text or Color3.new(1, 1, 1),
        TextScaled = true,
        TextWrapped = true,
    })

    TextSetColor1(_TextLabel)

    local _Frame2 = Create('Frame', _Frame, {
        Size = UDim2.new(0.27, 0, 0.15, 0),
        Position = UDim2.new(0.015, 0, 0.45, 0),
        BackgroundTransparency = 0,
    })

    Corner1(_Frame2)

    local _TextButton = Create('TextButton', _Frame2, {
        BackgroundColor3 = u1.Cor_Text,
        Size = UDim2.new(0.1, 0, 6, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = '',
    })

    Corner1(_TextButton)

    local _Frame3 = Create('Frame', _Frame2, {
        BackgroundColor3 = Color3.fromRGB(30, 140, 200),
        Size = UDim2.new(0.08, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
    })

    Corner1(_Frame3)

    local _TextLabel2 = Create('TextLabel', _Frame, {
        Font = u1.Text_Font,
        Size = UDim2.new(0.08, 0, 1, 0),
        Text = '0',
        Position = UDim2.new(0.305, 0, 0, 0),
        TextScaled = true,
        TextColor3 = u1.Cor_Text,
        BackgroundTransparency = 1,
    })
    local _UIScale = Create('UIScale', _TextLabel2)

    local function u82(p79)
        local v80 = tonumber(p79 * u65)
        local v81 = math.floor(v80 * 100) / 100

        u66 = v81
        _TextLabel2.Text = tostring(v81)

        task.spawn(u67, v81)
    end
    local function u85()
        local v83 = _UserInputService:GetMouseLocation().X - _Frame2.AbsolutePosition.X
        local v84 = math.clamp(v83 / _Frame2.AbsoluteSize.X, 0, 1)

        _Frame3.Size = UDim2.new(v84, 0, 1, 0)
        _TextButton.Position = UDim2.new(v84, 0, -2.5, 0)
    end

    u68.close1 = _TextButton.MouseButton1Down:Connect(function()
        CreateTween56(_TextButton, 'Transparency', 0, 0.3)

        while _UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            task.wait()
            u85()
        end

        CreateTween56(_TextButton, 'Transparency', 0.2, 0.3)
        u82(_TextButton.Position.X.Scale * (u70 - u71) + u71)
    end)

    local v86 = _TextButton

    u68.close2 = _TextButton.GetPropertyChangedSignal(v86, 'Position'):Connect(function()
        u82(_TextButton.Position.X.Scale * (u70 - u71) + u71)
    end)

    local v87 = _TextLabel2

    u68.close3 = _TextLabel2.GetPropertyChangedSignal(v87, 'Text'):Connect(function()
        _UIScale.Scale = 0.3

        CreateTween56(_UIScale, 'Scale', 1.2, 0.1)
        CreateTween56(_TextLabel2, 'Rotation', math.random(-1, 1) * 5, 0.15, true)
        CreateTween56(_UIScale, 'Scale', 1, 0.2)
        CreateTween56(_TextLabel2, 'Rotation', 0, 0.1)
    end)

    local function u92(p88)
        local v89 = u71 * u65
        local v90 = u70 * u65
        local v91 = (p88 - v89) / (v90 - v89)

        CreateTween56(_TextButton, 'Position', UDim2.new(v91, 0, -2.5, 0), 0.3, true)
        CreateTween56(_Frame3, 'Size', UDim2.new(v91, 0, 1, 0), 0.3, true)
        u82(p88)
    end

    u92(u66)

    local function v97()
        local v93, v94, v95 = pairs(u68)

        while true do
            local v96

            v95, v96 = v93(v94, v95)

            if v95 == nil then
                break
            end

            v96:Disconnect()
        end

        u68 = {}

        u92(0)
    end

    u68.close4 = _Frame.AncestryChanged:Connect(v97)
end
function AddDropdown(p98, p99)
    local v100 = p99.Name or 'Dropdown!!'
    local _ = p99.Default
    local v101 = p99.Options or {
        '1',
        '2',
        '3',
    }
    local u102 = p99.Default or '2'
    local u103 = p99.Callback or function() end
    local _TextButton2 = Create('TextButton', p98, {
        Size = UDim2.new(0.95, 0, 0.1, 0),
        BackgroundColor3 = u1.Cor_Options,
        Name = 'Frame',
        Text = '',
        AutoButtonColor = false,
    })

    Corner1(_TextButton2)
    Stroke1(_TextButton2)

    local _TextLabel3 = Create('TextLabel', _TextButton2, {
        TextColor3 = u1.Cor_Text,
        Text = v100,
        TextScaled = true,
        TextWrapped = true,
        Size = UDim2.new(0.72, 0, 1, 0),
        Position = UDim2.new(0.06, 0, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = 'Left',
        Font = u1.Text_Font,
    })

    TextSetColor1(_TextLabel3)

    local _Frame4 = Create('Frame', _TextButton2, {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = u1.Cor_Stroke,
        Visible = false,
    })
    local _ImageLabel = Create('ImageLabel', _TextButton2, {
        Image = 'rbxassetid://119823763721339',
        Size = UDim2.new(0.06, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    })
    local _TextLabel4 = Create('TextLabel', _TextButton2, {
        BackgroundColor3 = u1.Cor_Hub,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(1.04, -20, 0.04, 0),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0.2, 0, 0.9, 0),
        TextColor3 = u1.Cor_DarkText,
        TextScaled = true,
        Font = u1.Text_Font,
        Text = '...',
    })

    Corner1(_TextLabel4)
    Stroke1(_TextLabel4)

    local _ScrollingFrame = Create('ScrollingFrame', _TextButton2, {
        Size = UDim2.new(1, 0, 0.8, 0),
        Position = UDim2.new(0, 0, 0.3, 0),
        CanvasSize = UDim2.new(),
        ScrollingDirection = 'Y',
        AutomaticCanvasSize = 'Y',
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Visible = false,
    })

    Create('UIListLayout', _ScrollingFrame, {
        Padding = UDim.new(0, 2),
    })

    function AddOption(p110)
        local _TextButton3 = Create('TextButton', _ScrollingFrame, {
            Size = UDim2.new(1, 0, 0.2, 0),
            Text = p110,
            Font = u1.Text_Font,
            TextSize = 12,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            BackgroundTransparency = 1,
        })

        Corner1(_TextButton3)

        if p110 == u102 then
            _TextButton3.BackgroundTransparency = 0.8
            _TextButton3.TextColor3 = u1.Cor_Text
            _TextLabel4.Text = p110

            u103(p110)
        end

        _TextButton3.MouseButton1Click:Connect(function()
            local v112 = _ScrollingFrame
            local v113, v114, v115 = pairs(v112:GetChildren())

            while true do
                local v116

                v115, v116 = v113(v114, v115)

                if v115 == nil then
                    break
                end
                if v116:IsA('TextButton') then
                    v116.BackgroundTransparency = 1
                    v116.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end

            _TextLabel4.Text = p110

            u103(p110)

            _TextButton3.BackgroundTransparency = 0.8
            _TextButton3.TextColor3 = u1.Cor_Text
        end)

        _ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, _ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
    end

    local v117, v118, v119 = pairs(v101)
    local v120 = u103
    local u121 = _ScrollingFrame
    local u122 = _TextLabel4

    while true do
        local v123

        v119, v123 = v117(v118, v119)

        if v119 == nil then
            break
        end

        AddOption(v123)
    end

    local u124 = false
    local u125 = false

    _TextButton2.MouseButton1Click:Connect(function()
        if not u125 then
            u125 = true

            if u124 then
                CreateTween56(_TextButton2, 'Size', UDim2.new(0.95, 0, 0.1, 0), 0.3, false)
                CreateTween56(_ImageLabel, 'Rotation', 0, 0.3, true)

                u124 = false
                _Frame4.Visible = false
                u121.Visible = false
                _TextLabel3.Size = UDim2.new(0.72, 0, 1, 0)
                _ImageLabel.Size = UDim2.new(0.06, 0, 1, 0)
                u122.Size = UDim2.new(0.2, 0, 0.9, 0)
                _Frame4.Position = UDim2.new(0, 0, 0, 0)
                u121.Size = UDim2.new(1, 0, 0.8, 0)
            else
                _TextLabel3.Size = UDim2.new(0.72, 0, 0.27, 0)
                _ImageLabel.Size = UDim2.new(0.06, 0, 0.27, 0)
                u122.Size = UDim2.new(0.2, 0, 0.22, 0)
                _Frame4.Position = UDim2.new(0, 0, 0.28, 0)
                u121.Size = UDim2.new(1, 0, 0.7, 0)

                CreateTween56(_TextButton2, 'Size', UDim2.new(0.95, 0, 0.45, 0), 0.3, false)
                CreateTween56(_ImageLabel, 'Rotation', 180, 0.3, false)

                u124 = true
                _Frame4.Visible = true
                u121.Visible = true
            end

            u125 = false
        end
    end)

    return {
        u121,
        u102,
        v120,
        u122,
    }
end

local u126 = (not (is_sirhurt_closure or syn and DrawingImmediate) and (syn and syn.protect_gui) and true or false) and game:GetService('CoreGui') or (typeof(get_hidden_gui) == 'function' and get_hidden_gui() or typeof(gethui) == 'function' and gethui() or game:GetService('CoreGui'))
local v127, v128, v129 = pairs(u126:GetChildren())
local v130 = u3
local u131 = false

while true do
    local v132, v133 = v127(v128, v129)

    if v132 == nil then
        break
    end

    v129 = v132

    if v133.Name == 'MusicUI_MP3_DANHUB And wm67' then
        v133:Destroy()
    end
end

local _ScreenGui = Create('ScreenGui', u126, {
    Name = 'MusicUI_MP3_DANHUB And wm67',
    DisplayOrder = math.huge,
    IgnoreGuiInset = true,
})
local _Frame5 = Create('Frame', _ScreenGui, {
    Name = 'MainFrame',
    Size = UDim2.new(0.35, 0, 0.35, 0),
    Position = UDim2.new(0.2, 0, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    Active = true,
    Draggable = true,
})

Create('UICorner', _Frame5, {
    CornerRadius = UDim.new(0.05, 0),
})

local _ImageLabelWait = Create('ImageLabel', _Frame5, {
    Name = 'WaitImage',
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=127310698083&w=420&h=420',
    ScaleType = Enum.ScaleType.Fit,
})

local _Frame6 = Create('Frame', _Frame5, {
    Size = UDim2.new(0.6, 0, 0.2, 0),
    Position = UDim2.new(0.382, 0, 0.8, 0),
    BackgroundTransparency = 1,
})
local _ScrollingFrame2 = Create('ScrollingFrame', _Frame5, {
    Size = UDim2.new(1, 0, 0.58, 0),
    Position = UDim2.new(0, 0, 0.4, 0),
    CanvasSize = UDim2.new(),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    Visible = false,
})

Create('UIListLayout', _ScrollingFrame2, {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
})
Create('UIPadding', _ScrollingFrame2, {
    PaddingLeft = UDim.new(0.028, 0),
    PaddingBottom = UDim.new(0, 0.1),
})

local function u147(p144, p145)
    local v146 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    game:GetService('TweenService'):Create(p144, v146, {Position = p145}):Play()
end

_Frame5.DragStopped:Connect(function()
    local _AbsoluteSize = _ScreenGui.AbsoluteSize
    local _AbsoluteSize2 = _Frame5.AbsoluteSize
    local _Position = _Frame5.Position
    local _Offset = _Position.X.Offset
    local _Offset2 = _Position.Y.Offset

    if _Offset < 0 then
        _Offset = 0
    elseif _Offset + _AbsoluteSize2.X > _AbsoluteSize.X then
        _Offset = _AbsoluteSize.X - _AbsoluteSize2.X
    end
    if _Offset2 < 0 then
        _Offset2 = 0
    elseif _Offset2 + _AbsoluteSize2.Y > _AbsoluteSize.Y then
        _Offset2 = _AbsoluteSize.Y - _AbsoluteSize2.Y
    end

    u147(_Frame5, (UDim2.new(0, _Offset, 0, _Offset2)))
end)

local _TextLabel6 = Create('TextLabel', _Frame5, {
    Name = 'TitleLabel',
    Size = UDim2.new(0.9, 0, 0.15, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = songsmp3[u9].name,
    TextScaled = true,
    BackgroundTransparency = 1,
    Font = Enum.Font.FredokaOne,
})
local _TextButton4 = Create('TextButton', _Frame5, {
    Name = 'ToggleCloseMusicui',
    Size = UDim2.new(0.1, 0, 0.15, 0),
    Position = UDim2.new(0.9, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = '\u{fffd}',
    TextScaled = true,
    BackgroundTransparency = 1,
    Font = Enum.Font.FredokaOne,
})
local _ImageButton = Create('ImageButton', _Frame5, {
    Name = 'Switchmode',
    Size = UDim2.new(0.07, 0, 0.15, 0),
    Position = UDim2.new(0.915, 0, 0.15, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=93917932838439&w=150&h=150',
})
local _TextButton5 = Create('TextButton', _Frame5, {
    Name = 'ToggleSetting',
    Size = UDim2.new(0.3, 0, 0.1, 0),
    Position = UDim2.new(0, 0, -0.1, 0),
    Text = 'Setting: oFF',
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    BackgroundTransparency = 1,
    TextScaled = true,
    Font = u1.Text_Font,
    TextColor3 = u1.Cor_Text,
})
local _ImageLabel2 = Create('ImageLabel', _Frame5, {
    Name = 'ImageLabel',
    Size = UDim2.new(0.3, 0, 0.7, 0),
    Position = UDim2.new(0.05, 0, 0.2, 0),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=127310698083&w=420&h=420',
    ImageTransparency = 0,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 2,
})
Create('UICorner', _ImageLabel2, {
    CornerRadius = UDim.new(0.08, 0),
})

local _ImageButton2 = Create('ImageButton', _Frame5, {
    Name = 'PlayPauseButton',
    Size = UDim2.new(0.1, 0, 0.23, 0),
    Position = UDim2.new(0.65, 0, 0.65, 0),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=98070627958036&w=150&h=150',
})
local _ImageButton3 = Create('ImageButton', _Frame5, {
    Name = 'NextButton',
    Size = UDim2.new(0.1, 0, 0.23, 0),
    Position = UDim2.new(0.8, 0, 0.65, 0),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=108701088493396&w=150&h=150',
})
local _ImageButton4 = Create('ImageButton', _Frame5, {
    Name = 'PreviousButton',
    Size = UDim2.new(0.1, 0, 0.23, 0),
    Position = UDim2.new(0.5, 0, 0.65, 0),
    BackgroundTransparency = 1,
    Image = 'rbxthumb://type=Asset&id=135009931121404&w=150&h=150',
})
local _TextLabel7 = Create('TextLabel', _Frame5, {
    Name = 'TimeLabel',
    Size = UDim2.new(0.3, 0, 0.1, 0),
    Position = UDim2.new(0.53, 0, 0.4, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = '0:00 / 0:00',
    TextScaled = true,
    Font = Enum.Font.FredokaOne,
})
local _TextLabel8 = Create('TextLabel', _TextLabel7, {
    Name = 'Credit',
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, -1, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = 'Script Make by DANHUB And wm67',
    TextScaled = true,
    Font = Enum.Font.FredokaOne,
})
local _TextLabel9 = Create('TextLabel', _TextLabel7, {
    Name = 'Version',
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, -2, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = 'Version: 1',
    TextScaled = true,
    Font = Enum.Font.FredokaOne,
})
local _Frame7 = Create('Frame', _Frame5, {
    Name = 'ProgressBarBackground',
    Size = UDim2.new(0.5, 0, 0.05, 0),
    Position = UDim2.new(0.43, 0, 0.52, 0),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
})

Create('UICorner', _Frame7, {
    CornerRadius = UDim.new(1, 0),
})

local _Frame8 = Create('Frame', _Frame7, {
    Name = 'ProgressFill',
    Size = UDim2.new(0, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(0, 170, 255),
})

Create('UICorner', _Frame8, {
    CornerRadius = UDim.new(1, 0),
})

local _Frame9 = Create('Frame', _ScreenGui, {
    Name = 'FrameSetting',
    Size = UDim2.new(0.3, 0, 0.9, 0),
    Position = UDim2.new(0.35, 0, 0.05, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    Visible = false,
})

Create('TextLabel', _Frame9, {
    Name = 'Version',
    Size = UDim2.new(1, 0, 0.1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Text = 'Setting Menu',
    TextScaled = true,
    Font = Enum.Font.FredokaOne,
})

local _ScrollingFrame3 = Create('ScrollingFrame', _Frame9, {
    Name = 'Setting',
    Size = UDim2.new(1, 0, 0.9, 0),
    Position = UDim2.new(0, 0, 0.1, 0),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
})

Create('UIListLayout', _ScrollingFrame3, {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
})
Create('UIPadding', _ScrollingFrame3, {
    PaddingLeft = UDim.new(0.028, 0),
    PaddingBottom = UDim.new(0, 0.1),
})

local _Frame10 = Create('Frame', _ScrollingFrame3, {
    Size = UDim2.new(0.95, 0, 0.1, 0),
    BackgroundColor3 = u1 and u1.Cor_Options or Color3.new(0.2, 0.2, 0.2),
    BackgroundTransparency = 0,
})

Corner1(_Frame10)
Stroke1(_Frame10)

local _TextLabel10 = Create('TextLabel', _Frame10, {
    Size = UDim2.new(0.6, 0, 1, 0),
    TextSize = 7,
    TextWrapped = true,
    BackgroundTransparency = 1,
    TextColor3 = u1.Cor_Text,
    TextXAlignment = 'Left',
    Text = 'Play Song Mod',
})

TextSetColor1(_TextLabel10)

local _TextButton6 = Create('TextButton', _Frame10, {
    Size = UDim2.new(0.3, 0, 1, 0),
    Position = UDim2.new(0.65, 0, 0, 0),
    Text = 'OFF',
    TextSize = 7,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = u1.Cor_Text,
    BackgroundTransparency = 1,
})

Corner1(_TextButton6)
TextSetColor1(_TextButton6)

local _Frame11 = Create('Frame', _ScrollingFrame3, {
    Size = UDim2.new(0.95, 0, 0.1, 0),
    BackgroundColor3 = u1 and u1.Cor_Options or Color3.new(0.2, 0.2, 0.2),
    BackgroundTransparency = 0,
})

Corner1(_Frame11)
Stroke1(_Frame11)

local _TextLabel11 = Create('TextLabel', _Frame11, {
    Size = UDim2.new(0.6, 0, 1, 0),
    TextSize = 7,
    TextWrapped = true,
    BackgroundTransparency = 1,
    TextColor3 = u1.Cor_Text,
    TextXAlignment = 'Left',
    Text = 'Effect Song',
})

TextSetColor1(_TextLabel11)

local _TextButton7 = Create('TextButton', _Frame11, {
    Size = UDim2.new(0.3, 0, 1, 0),
    Position = UDim2.new(0.65, 0, 0, 0),
    Text = 'OFF',
    TextSize = 7,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = u1.Cor_Text,
    BackgroundTransparency = 1,
})

Corner1(_TextButton7)
TextSetColor1(_TextButton7)

local u174 = false
local u175 = false
local u176 = true

_TextButton4.MouseButton1Click:Connect(function()
    if u176 then
        u176 = false

        if u174 then
            if u131 then
                CreateTween56(_Frame5, 'Size', UDim2.new(0.3, 0, 0.87, 0), 0.2, false)

                _TextLabel6.Visible = true
                _ImageButton2.Visible = true
                _ImageButton3.Visible = true
                _ImageButton4.Visible = true
                _TextLabel7.Visible = true
                _Frame7.Visible = true
                _ScrollingFrame2.Visible = true
                _TextButton5.Visible = true
                _TextLabel8.Visible = false
                _TextLabel9.Visible = false
                _TextButton5.Size = UDim2.new(0.3, 0, 0.05, 0)
                _TextButton5.Position = UDim2.new(0.05, 0, 0.02, 0)
                _TextButton4.Size = UDim2.new(0.1, 0, 0.1, 0)
                _TextButton4.Position = UDim2.new(0.9, 0, 0, 0)
                _TextButton4.Text = '\u{fffd}'
                _ImageLabel2.Size = UDim2.new(0.3, 0, 0.25, 0)
                _ImageLabel2.Position = UDim2.new(0.05, 0, 0.1, 0)
                _Frame6.Size = UDim2.new(0.91, 0, 0.2, 0)
                _Frame6.Position = UDim2.new(0.05, 0, 0.8, 0)
                _ImageButton.Size = UDim2.new(0.07, 0, 0.05, 0)
                _ImageButton.Position = UDim2.new(0.83, 0, 0.032, 0)
                _Frame7.Size = UDim2.new(0.9, 0, 0.025, 0)
                _Frame7.Position = UDim2.new(0.05, 0, 0.36, 0)
                _TextLabel6.Size = UDim2.new(0.61, 0, 0.08, 0)
                _TextLabel6.Position = UDim2.new(0.37, 0, 0.1, 0)
                _ImageButton2.Size = UDim2.new(0.1, 0, 0.08, 0)
                _ImageButton2.Position = UDim2.new(0.6, 0, 0.28, 0)
                _ImageButton3.Size = UDim2.new(0.1, 0, 0.08, 0)
                _ImageButton3.Position = UDim2.new(0.75, 0, 0.28, 0)
                _ImageButton4.Size = UDim2.new(0.1, 0, 0.08, 0)
                _ImageButton4.Position = UDim2.new(0.45, 0, 0.28, 0)
                _TextLabel7.Size = UDim2.new(0.3, 0, 0.08, 0)
                _TextLabel7.Position = UDim2.new(0.5, 0, 0.19, 0)

                Create('UICorner', _Frame5, {
                    CornerRadius = UDim.new(0.05, 0),
                })
                Create('UICorner', _Frame7, {
                    CornerRadius = UDim.new(1, 0),
                })
                Create('UICorner', _Frame8, {
                    CornerRadius = UDim.new(1, 0),
                })

                _Frame5.Active = true
                _Frame5.Draggable = true
            else
                CreateTween56(_Frame5, 'Size', UDim2.new(0.35, 0, 0.32, 0), 0.2, false)

                _TextLabel6.Visible = true
                _ImageButton2.Visible = true
                _ImageButton3.Visible = true
                _ImageButton4.Visible = true
                _TextLabel7.Visible = true
                _Frame7.Visible = true
                _ScrollingFrame2.Visible = false
                _TextLabel8.Visible = true
                _TextButton5.Visible = true
                _TextLabel9.Visible = true
                _TextButton5.Size = UDim2.new(0.3, 0, 0.1, 0)
                _TextButton5.Position = UDim2.new(0, 0, -0.1, 0)
                _TextButton4.Size = UDim2.new(0.1, 0, 0.15, 0)
                _TextButton4.Position = UDim2.new(0.9, 0, 0, 0)
                _TextButton4.Text = '\u{fffd}'
                _ImageLabel2.Size = UDim2.new(0.3, 0, 0.7, 0)
                _ImageLabel2.Position = UDim2.new(0.05, 0, 0.2, 0)
                _Frame6.Size = UDim2.new(0.6, 0, 0.2, 0)
                _Frame6.Position = UDim2.new(0.382, 0, 0.8, 0)
                _ImageButton.Size = UDim2.new(0.07, 0, 0.15, 0)
                _ImageButton.Position = UDim2.new(0.915, 0, 0.15, 0)
                _Frame7.Size = UDim2.new(0.5, 0, 0.05, 0)
                _Frame7.Position = UDim2.new(0.43, 0, 0.52, 0)
                _TextLabel6.Size = UDim2.new(0.9, 0, 0.15, 0)
                _TextLabel6.Position = UDim2.new(0, 0, 0, 0)
                _ImageButton2.Size = UDim2.new(0.1, 0, 0.23, 0)
                _ImageButton2.Position = UDim2.new(0.65, 0, 0.65, 0)
                _ImageButton3.Size = UDim2.new(0.1, 0, 0.23, 0)
                _ImageButton3.Position = UDim2.new(0.8, 0, 0.65, 0)
                _ImageButton4.Size = UDim2.new(0.1, 0, 0.23, 0)
                _ImageButton4.Position = UDim2.new(0.5, 0, 0.65, 0)
                _TextLabel7.Size = UDim2.new(0.3, 0, 0.1, 0)
                _TextLabel7.Position = UDim2.new(0.53, 0, 0.4, 0)

                Create('UICorner', _Frame5, {
                    CornerRadius = UDim.new(0, 0),
                })
                Create('UICorner', _Frame7, {
                    CornerRadius = UDim.new(0, 0),
                })
                Create('UICorner', _Frame8, {
                    CornerRadius = UDim.new(0, 0),
                })

                _Frame5.Active = true
                _Frame5.Draggable = true
            end
        else
            CreateTween56(_Frame9, 'Size', UDim2.new(0.3, 0, 0, 0), 0.2, false)
            CreateTween56(_Frame5, 'Size', UDim2.new(0.0425, 0, 0.092, 0), 0.2, false)
            CreateTween56(_Frame5, 'Position', UDim2.new(0.05, 0, 0.2, 0), 0.2, true)

            _TextLabel6.Visible = false
            _ImageButton2.Visible = false
            _ImageButton3.Visible = false
            _ImageButton4.Visible = false
            _TextLabel7.Visible = false
            _Frame7.Visible = false
            _ScrollingFrame2.Visible = false
            _TextLabel8.Visible = false
            _TextLabel9.Visible = false
            _Frame9.Visible = false
            _TextButton5.Text = 'Setting: oFF'
            u175 = true
            _TextButton5.Visible = false
            _TextButton4.Size = UDim2.new(1, 0, 1, 0)
            _TextButton4.Position = UDim2.new(0, 0, 0, 0)
            _TextButton4.Text = ''
            _ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
            _ImageLabel2.Position = UDim2.new(0, 0, 0, 0)
            _Frame5.Active = false
            _Frame5.Draggable = false
        end

        u174 = not u174
        u176 = true
    end
end)
_ImageButton.MouseButton1Click:Connect(function()
    if u176 then
        u176 = false

        if u131 then
            u131 = false

            CreateTween56(_Frame5, 'Size', UDim2.new(0.35, 0, 0.35, 0), 0.2, false)

            _TextLabel6.Visible = true
            _ImageButton2.Visible = true
            _ImageButton3.Visible = true
            _ImageButton4.Visible = true
            _TextLabel7.Visible = true
            _Frame7.Visible = true
            _ScrollingFrame2.Visible = false
            _TextLabel8.Visible = true
            _TextLabel9.Visible = true
            _TextButton5.Size = UDim2.new(0.3, 0, 0.1, 0)
            _TextButton5.Position = UDim2.new(0, 0, -0.1, 0)
            _TextButton4.Size = UDim2.new(0.1, 0, 0.15, 0)
            _TextButton4.Position = UDim2.new(0.9, 0, 0, 0)
            _ImageLabel2.Size = UDim2.new(0.3, 0, 0.7, 0)
            _ImageLabel2.Position = UDim2.new(0.05, 0, 0.2, 0)
            _Frame6.Size = UDim2.new(0.6, 0, 0.2, 0)
            _Frame6.Position = UDim2.new(0.382, 0, 0.8, 0)
            _ImageButton.Size = UDim2.new(0.07, 0, 0.15, 0)
            _ImageButton.Position = UDim2.new(0.915, 0, 0.15, 0)
            _Frame7.Size = UDim2.new(0.5, 0, 0.05, 0)
            _Frame7.Position = UDim2.new(0.43, 0, 0.52, 0)
            _TextLabel6.Size = UDim2.new(0.9, 0, 0.15, 0)
            _TextLabel6.Position = UDim2.new(0, 0, 0, 0)
            _ImageButton2.Size = UDim2.new(0.1, 0, 0.23, 0)
            _ImageButton2.Position = UDim2.new(0.65, 0, 0.65, 0)
            _ImageButton3.Size = UDim2.new(0.1, 0, 0.23, 0)
            _ImageButton3.Position = UDim2.new(0.8, 0, 0.65, 0)
            _ImageButton4.Size = UDim2.new(0.1, 0, 0.23, 0)
            _ImageButton4.Position = UDim2.new(0.5, 0, 0.65, 0)
            _TextLabel7.Size = UDim2.new(0.3, 0, 0.1, 0)
            _TextLabel7.Position = UDim2.new(0.53, 0, 0.4, 0)
        else
            u131 = true

            CreateTween56(_Frame5, 'Size', UDim2.new(0.3, 0, 0.82, 0), 0.2, false)

            _TextLabel6.Visible = true
            _ImageButton2.Visible = true
            _ImageButton3.Visible = true
            _ImageButton4.Visible = true
            _TextLabel7.Visible = true
            _Frame7.Visible = true
            _ScrollingFrame2.Visible = true
            _TextLabel8.Visible = false
            _TextLabel9.Visible = false
            _TextButton5.Size = UDim2.new(0.3, 0, 0.05, 0)
            _TextButton5.Position = UDim2.new(0.05, 0, 0.02, 0)
            _TextButton4.Size = UDim2.new(0.1, 0, 0.1, 0)
            _TextButton4.Position = UDim2.new(0.9, 0, 0, 0)
            _ImageLabel2.Size = UDim2.new(0.3, 0, 0.25, 0)
            _ImageLabel2.Position = UDim2.new(0.05, 0, 0.1, 0)
            _Frame6.Size = UDim2.new(0.91, 0, 0.2, 0)
            _Frame6.Position = UDim2.new(0.05, 0, 0.8, 0)
            _ImageButton.Size = UDim2.new(0.07, 0, 0.05, 0)
            _ImageButton.Position = UDim2.new(0.83, 0, 0.032, 0)
            _Frame7.Size = UDim2.new(0.9, 0, 0.025, 0)
            _Frame7.Position = UDim2.new(0.05, 0, 0.36, 0)
            _TextLabel6.Size = UDim2.new(0.61, 0, 0.08, 0)
            _TextLabel6.Position = UDim2.new(0.37, 0, 0.1, 0)
            _ImageButton2.Size = UDim2.new(0.1, 0, 0.08, 0)
            _ImageButton2.Position = UDim2.new(0.6, 0, 0.28, 0)
            _ImageButton3.Size = UDim2.new(0.1, 0, 0.08, 0)
            _ImageButton3.Position = UDim2.new(0.75, 0, 0.28, 0)
            _ImageButton4.Size = UDim2.new(0.1, 0, 0.08, 0)
            _ImageButton4.Position = UDim2.new(0.45, 0, 0.28, 0)
            _TextLabel7.Size = UDim2.new(0.3, 0, 0.08, 0)
            _TextLabel7.Position = UDim2.new(0.5, 0, 0.19, 0)
        end

        u176 = true
    end
end)
_TextButton5.MouseButton1Click:Connect(function()
    if u176 then
        u176 = false

        if u175 then
            _TextButton5.Text = 'Setting: oN'
            u175 = false
            _Frame9.Visible = true

            CreateTween56(_Frame9, 'Size', UDim2.new(0.3, 0, 0.9, 0), 0.2, false)
        else
            _TextButton5.Text = 'Setting: oFF'
            u175 = true

            CreateTween56(_Frame9, 'Size', UDim2.new(0.3, 0, 0, 0), 0.2, true)

            _Frame9.Visible = false
        end

        u176 = true
    end
end)

local _Sound2 = Create('Sound', _ScreenGui, {
    Name = 'soundmusicmp3_hcx',
    Volume = _SavedVolume,
})
local _ReverbSoundEffect = Create('ReverbSoundEffect', _Sound2)
local _ChorusSoundEffect = Create('ChorusSoundEffect', _Sound2)
local u180 = _SavedTimePosition
local u181 = 0

local function saveMusicState()
    local vTimePosition = math.max(_Sound2.TimePosition or u180 or 0, 0)

    if not _Sound2.IsPlaying then
        vTimePosition = math.max(u180 or 0, vTimePosition)
    end

    local vState = {
        volume = math.clamp(_Sound2.Volume or _SavedVolume, 0, 2.5),
        songIndex = math.clamp(math.floor(u9 or 1), 1, #songsmp3),
        timePosition = vTimePosition,
    }
    local vEncodeOk, vEncodedState = pcall(function()
        return _HttpService:JSONEncode(vState)
    end)

    if vEncodeOk then
        pcall(function()
            writefile(_MusicStateFile, vEncodedState)
        end)
    end
end

_ChorusSoundEffect.Enabled = false
_ReverbSoundEffect.Enabled = false

local u182 = true
local v183 = 55
local u184 = 1 / v183
local u185 = {}
local u186 = {
    'OFF',
    'Auto Play Next',
    'Auto Reverse',
    'Auto Loop',
}
local u187 = 1
local u188 = 1

local function v189()
    u187 = u187 + 1

    if u187 > #u186 then
        u187 = 1
    end

    _TextButton6.Text = u186[u187]
end

local u190 = _Sound2.Ended:Connect(function()
    if _Sound2.TimeLength then
        u182 = true
    end
    if u187 ~= 1 then
        if u187 ~= 2 then
            if u187 ~= 3 then
                if u187 == 4 then
                    loadSong(u9)
                end
            else
                changeSong(u9 - 1)
            end
        else
            changeSong(u9 + 1)
        end
    end
end)

_TextButton6.MouseButton1Click:Connect(v189)

local _Frame12 = Create('Frame', _ScrollingFrame3, {
    Size = UDim2.new(0.95, 0, 0.1, 0),
    BackgroundColor3 = u1 and u1.Cor_Options or Color3.new(0.2, 0.2, 0.2),
    BackgroundTransparency = 0,
})

Corner1(_Frame12)
Stroke1(_Frame12)

local _TextLabel12 = Create('TextLabel', _Frame12, {
    Size = UDim2.new(0.6, 0, 1, 0),
    TextScaled = true,
    TextWrapped = true,
    BackgroundTransparency = 1,
    TextColor3 = u1.Cor_Text,
    TextXAlignment = 'Left',
    Text = 'Shake Camera Music',
})

TextSetColor1(_TextLabel12)

local _TextButton8 = Create('TextButton', _Frame12, {
    Size = UDim2.new(0.3, 0, 1, 0),
    Position = UDim2.new(0.65, 0, 0, 0),
    Text = 'Shake: OFF',
    TextScaled = true,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = u1.Cor_Text,
    BackgroundTransparency = 1,
})

Corner1(_TextButton8)
TextSetColor1(_TextButton8)

local _RunService2 = game:GetService('RunService')

game:GetService('TweenService')

local _LocalPlayer = game.Players.LocalPlayer
local u196 = _Sound2
local u197 = _TextButton8
local u198 = 60
local u199 = {}
local u200 = {}
local u201 = {}
local u202 = {}
local u203 = {}
local u204 = {}
local u205 = false
local u206 = nil
local _CurrentCamera = workspace.CurrentCamera
local _FieldOfView = _CurrentCamera.FieldOfView
local u209 = 10
local u210 = Vector3.new()
local u211 = Vector3.new()
local u212 = 0
local u213 = 0
local u214 = 0

local function u222(p215)
    local v216 = #p215

    if v216 == 0 then
        return 0, 0
    end

    local v217 = 0

    for v218 = 1, v216 do
        v217 = v217 + p215[v218]
    end

    local v219 = v217 / v216
    local v220 = 0

    for v221 = 1, v216 do
        v220 = v220 + (p215[v221] - v219) ^ 2
    end

    return v219, math.sqrt(v220 / v216)
end
local function u227(p223, p224)
    local v225 = 0

    for v226 = 2, #p223 do
        if p224 < math.abs(p223[v226] - p223[v226 - 1]) then
            v225 = v225 + 1
        end
    end

    return v225
end
local function u232(p228, p229)
    local v230 = p228 * 3
    local v231 = math.clamp(p229, 1, 3)

    return math.clamp(v231 * p228, p228, v230)
end

u197.MouseButton1Click:Connect(function()
    if u205 then
        u205 = false
        u197.Text = 'Shake: OFF'

        if u206 then
            u206:Disconnect()

            u206 = nil
        end

        local _Character = _LocalPlayer.Character
        local v234 = _Character and _Character:FindFirstChildOfClass('Humanoid')

        if v234 then
            v234.CameraOffset = Vector3.new()
        end

        _CurrentCamera.FieldOfView = _FieldOfView
        u210 = Vector3.new()
        u211 = Vector3.new()
        u212 = 0
        u213 = 0
        u214 = 0
    else
        u205 = true
        u197.Text = 'Shake: ON'

        local u235 = 0
        local u236 = 8
        local u237 = 2
        local u238 = 8
        local u239 = 2
        local u240 = 0.3

        u206 = _RunService2.RenderStepped:Connect(function(p241)
            if u205 and u196.Playing then
                local v242 = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()
                local v243 = v242:FindFirstChildOfClass('Humanoid') or v242:WaitForChild('Humanoid')
                local v244 = u196.PlaybackLoudness or 0
                local v245 = u196.PlaybackSpeed or 1
                local v246 = u196.Volume or 1
                local v247 = u196.Pitch or 1

                table.insert(u199, v244)

                if u198 < #u199 then
                    table.remove(u199, 1)
                end

                table.insert(u200, v245)

                if u198 < #u200 then
                    table.remove(u200, 1)
                end

                table.insert(u201, v246)

                if u198 < #u201 then
                    table.remove(u201, 1)
                end

                table.insert(u202, v247)

                if u198 < #u202 then
                    table.remove(u202, 1)
                end

                local v248, v249 = u222(u199)
                local v250, v251 = u222(u200)
                local v252, v253 = u222(u201)
                local v254, v255 = u222(u202)
                local v256 = v249 > 0 and (math.abs(v244 - v248) / v249 or 0) or 0
                local v257 = v251 > 0 and (math.abs(v245 - v250) / v251 or 0) or 0
                local v258 = 0 < v253 and math.abs(v246 - v252) / v253 or 0
                local v259 = v255 > 0 and (math.abs(v247 - v254) / v255 or 0) or 0
                local v260 = v256 * 1.5 + v257 * 5 + v258 * 3 + v259 * 2

                if u235 < v244 then
                    u235 = v244
                end

                local v261 = (u235 <= 0 and 0 or (math.clamp(v244 / u235, 0, 1) or 0)) * v260
                local v262 = v261 < u240 and 0 or v261
                local v263 = math.clamp(v262 * 10, 0, u209)
                local v264 = math.clamp((v244 - v248) * 0.005, 0.01, 0.3)
                local v265 = 2 + (v245 - v250) * 0.5
                local v266 = math.max(v264, 0.01)
                local v267 = math.max(v265, 1)
                local v268 = 0.5 + math.clamp(v260 / 5, 0, 2)
                local v269 = 0.5 + math.clamp(v260 / 3, 0, 3)
                local v270 = u202[#u202 - 1] or v247
                local v271 = math.abs(v247 - v270)

                table.insert(u203, v271)

                if #u203 > 15 then
                    table.remove(u203, 1)
                end

                local v272 = u227(u203, 0.05)
                local v273 = v267 * (v269 + math.clamp(v272 / 15, 0, 1) * 1.5)
                local v274 = v266 * v268
                local v275 = tick()
                local v276 = math.sin(v275 * 2 * math.pi * v273 * 2) * v274 * 0.5 * -1
                local v277 = math.sin(v275 * 2 * math.pi * v273) * v274

                u210 = Vector3.new(0, v276, v277)

                table.insert(u204, u210)

                if #u204 > 3 then
                    table.remove(u204, 1)
                end

                local v278 = Vector3.new()
                local v279, v280, v281 = pairs(u204)

                while true do
                    local v282

                    v281, v282 = v279(v280, v281)

                    if v281 == nil then
                        break
                    end

                    v278 = v278 + v282
                end

                local v283 = v278 / #u204
                local v284 = u232(u236, v245)
                local v285 = u232(u237, v245)

                if v283.Magnitude > u211.Magnitude and v284 then
                    v285 = v284
                end

                u211 = u211:Lerp(v283, math.clamp(v285 * p241, 0, 1))
                v243.CameraOffset = u211

                local v286 = u232(u238, v245)
                local v287 = u232(u239, v245)

                if u214 < v263 and v286 then
                    v287 = v286
                end

                u214 = u214 + (v263 - u214) * math.clamp(v287 * p241, 0, 1)
                _CurrentCamera.FieldOfView = _FieldOfView + u214
            end
        end)
    end
end)
AddSlider56(_ScrollingFrame3, {
    Name = 'Adjust volume',
    MinValue = 0,
    MaxValue = 2.5,
    Increase = 0.1,
    Default = _Sound2.Volume,
    Callback = function(p288)
        _Sound2.Volume = p288
        saveMusicState()
    end,
})

local v290 = {
    Name = 'Select Speed Song',
    Default = '1',
    Options = {
        '0.1',
        '0.2',
        '0.3',
        '0.4',
        '0.5',
        '0.6',
        '0.7',
        '0.8',
        '0.9',
        '1',
        '1.1',
        '1.2',
        '1.3',
        '1.4',
        '1.5',
        '1.6',
        '1.7',
        '1.8',
        '1.9',
        '2',
    },
    Callback = function(p289)
        if p289 then
            u188 = tonumber(p289)

            if _Sound2 then
                _Sound2.PlaybackSpeed = u188
                _Sound2.Pitch = u188
            end
        end
    end,
}

AddDropdown(_ScrollingFrame3, v290)

local _Frame13 = Create('Frame', _ScrollingFrame3, {
    Size = UDim2.new(0.95, 0, 0.1, 0),
    BackgroundColor3 = u1 and u1.Cor_Options or Color3.new(0.2, 0.2, 0.2),
    BackgroundTransparency = 0,
})

Corner1(_Frame13)
Stroke1(_Frame13)

local _TextLabel13 = Create('TextLabel', _Frame13, {
    Size = UDim2.new(0.6, 0, 1, 0),
    TextScaled = true,
    TextWrapped = true,
    BackgroundTransparency = 1,
    TextColor3 = u1.Cor_Text,
    TextXAlignment = 'Left',
    Text = 'Are you sure',
})

TextSetColor1(_TextLabel13)

local _TextButton9 = Create('TextButton', _Frame13, {
    Size = UDim2.new(0.3, 0, 1, 0),
    Position = UDim2.new(0.65, 0, 0, 0),
    Text = 'Close Script',
    TextScaled = true,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = u1.Cor_Text,
    BackgroundTransparency = 1,
})

Corner1(_TextButton9)
TextSetColor1(_TextButton9)
_TextButton9.MouseButton1Click:Connect(function()
    saveMusicState()
    _ScreenGui:Destroy()
end)
_TextButton7.MouseButton1Click:Connect(function()
    if u181 ~= 0 then
        if u181 ~= 1 then
            _ChorusSoundEffect.Enabled = false
            _ReverbSoundEffect.Enabled = false
            u181 = 0
            _TextButton7.Text = 'OFF'
        else
            _ChorusSoundEffect.Enabled = true
            _ReverbSoundEffect.Enabled = false
            u181 = 2
            _TextButton7.Text = 'Chorus'
        end
    else
        _ChorusSoundEffect.Enabled = false
        _ReverbSoundEffect.Enabled = true
        u181 = 1
        _TextButton7.Text = 'Reverb'
    end
end)

local u294 = u206
local u295 = u182
local u296 = _Sound2

for v297 = 1, v183 do
    local _Frame14 = Create('Frame', _Frame6, {
        Size = UDim2.new(u184, 0, 0.8, 0),
        Position = UDim2.new((v297 - 1) * u184, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(0, 255, 255),
        BackgroundTransparency = 0.2,
    })

    Create('UICorner', _Frame14, {
        CornerRadius = UDim.new(0.3, 0),
    })
    table.insert(u185, _Frame14)

    local v299, v300, v301 = pairs(u185)

    while true do
        local v302

        v301, v302 = v299(v300, v301)

        if v301 == nil then
            break
        end

        local v303 = u296.PlaybackLoudness / 1000 * u296.PlaybackSpeed or u296.Pitch * u296.Volume

        CreateTween56(v302, 'Size', UDim2.new(1 / v183, -2, v303, 0), 0.2, false)
    end
end

function pausesongMusic()
    u180 = u296.TimePosition

    u296:Pause()
    saveMusicState()

    u295 = true
end
function loadSong(p304)
    local v305 = songsmp3[p304]
    local _id = v305.id
    local v307 = v305.file or ('song' .. p304 .. '.mp3')

    u296.SoundId = validateAndConvertMP3(_id, v307)
    u296.TimePosition = u180

    u296:Play()
    saveMusicState()

    _TextLabel6.Text = v305.name
    _ImageLabel2.Image = v305.imageId
end
function Updatesong()
    local v308 = _ScrollingFrame2
    local v309, v310, v311 = ipairs(v308:GetChildren())

    while true do
        local v312, v313 = v309(v310, v311)

        if v312 == nil then
            break
        end

        v311 = v312

        if v313:IsA('Frame') and v313.Name ~= 'UIListLayout' then
            v313:Destroy()
        end
    end

    local v314, v315, v316 = ipairs(songsmp3)

    while true do
        local u317, u318 = v314(v315, v316)

        if u317 == nil then
            break
        end

        v316 = u317

        local _Frame15 = Create('Frame', _ScrollingFrame2, {
            BackgroundColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0.96, 0, 0.12, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
        })

        if not _Frame15:FindFirstChild('iconmusicmp3') then
            Create('ImageLabel', _Frame15, {
                Name = 'iconmusicmp3',
                Size = UDim2.new(0.1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Image = u318.imageId,
            })
        end
        if not _Frame15:FindFirstChild('NameLabel') then
            Create('TextLabel', _Frame15, {
                Name = 'NameLabel',
                Text = tostring(u317) .. '.' .. u318.name,
                Size = UDim2.new(0.89, 0, 1, 0),
                Position = UDim2.new(0.11, 0, 0, 0),
                TextScaled = true,
                TextColor3 = u1.Cor_Text,
                TextXAlignment = 'Left',
                Font = u1.Text_Font,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
            })
        end
        if not _Frame15:FindFirstChild('SongButton') then
            Create('TextButton', _Frame15, {
                Name = 'SongButton',
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                TextColor3 = u1.Cor_Text,
                Font = u1.Text_Font,
                Text = '',
                BackgroundTransparency = 1,
            }).MouseButton1Click:Connect(function()
                u296:Stop()

                u180 = 0
                u9 = u317

                loadSong(u9)

                _ImageButton2.Image = 'rbxthumb://type=Asset&id=133872094700280&w=150&h=150'

                Updatesong()

                _TextLabel6.Text = u318.name
                _ImageLabel2.Image = u318.imageId
            end)
        end
    end

    local v320 = _ScrollingFrame2
    local v321, v322, v323 = ipairs(v320:GetChildren())

    while true do
        local v324, v325 = v321(v322, v323)

        if v324 == nil then
            break
        end

        v323 = v324

        if v325:IsA('Frame') and v325:FindFirstChild('NameLabel') then
            local _NameLabel = v325.NameLabel

            if u9 ~= tonumber(_NameLabel.Text:match('^(%d+)')) then
                CreateTween56(_NameLabel, 'TextColor3', u1.Cor_Text, 0.3, false)
            else
                CreateTween56(_NameLabel, 'TextColor3', Color3.fromRGB(0, 170, 255), 0.3, false)
            end
        end
    end
end

Updatesong()

function changeSong(p327)
    u9 = p327

    if u9 >= 1 then
        if u9 > #songsmp3 then
            u9 = 1
        end
    else
        u9 = #songsmp3
    end

    u296:Stop()

    u180 = 0

    loadSong(u9)
    Updatesong()

    _ImageButton2.Image = 'rbxthumb://type=Asset&id=133872094700280&w=150&h=150'
    u295 = false
end

_ImageButton2.MouseButton1Click:Connect(function()
    if u295 then
        loadSong(u9)

        u296.TimePosition = u180
        _ImageButton2.Image = 'rbxthumb://type=Asset&id=133872094700280&w=150&h=150'
        u295 = false
    else
        pausesongMusic()

        _ImageButton2.Image = 'rbxthumb://type=Asset&id=98070627958036&w=150&h=150'
    end
end)
_ImageButton3.MouseButton1Click:Connect(function()
    changeSong(u9 + 1)
end)
_ImageButton4.MouseButton1Click:Connect(function()
    changeSong(u9 - 1)
end)

local u341 = 0
local u339 = game:GetService('RunService').RenderStepped:Connect(function()
    if u296.IsPlaying then
        if tick() - u341 >= 3 then
            u180 = u296.TimePosition
            saveMusicState()
            u341 = tick()
        end
        local v328 = math.floor(u296.TimePosition)
        local v329 = math.floor(u296.TimeLength)
        local v330 = math.floor(v328 / 60)
        local v331 = v328 % 60
        local v332 = math.floor(v329 / 60)
        local v333 = v329 % 60

        _TextLabel7.Text = string.format('%d:%02d / %d:%02d', v330, v331, v332, v333)

        if v329 > 0 then
            _Frame8.Size = UDim2.new(v328 / v329, 0, 1, 0)
        end

        local v334, v335, v336 = ipairs(u185)

        while true do
            local v337

            v336, v337 = v334(v335, v336)

            if v336 == nil then
                break
            end

            local v338 = math.random() * (u296.PlaybackLoudness / 1000) * u296.PlaybackSpeed or u296.Pitch * u296.Volume

            CreateTween56(v337, 'Size', UDim2.new(u184, -2, v338, 0), 0.2, false)
        end
    elseif u296.TimeLength then
        _ImageButton2.Image = 'rbxthumb://type=Asset&id=98070627958036&w=150&h=150'
    end
end)
local u340 = nil

u340 = _ScreenGui.AncestryChanged:Connect(function()
    if not u126:FindFirstChild(_ScreenGui.Name) then
        saveMusicState()
        u296:Destroy()
        _ReverbSoundEffect:Destroy()
        _ChorusSoundEffect:Destroy()

        if u339 then
            u339:Disconnect()

            u339 = nil
        end
        if u190 then
            u190:Disconnect()

            u190 = nil
        end
        if u294 then
            u294:Disconnect()

            u294 = nil
        end
        if u340 then
            u340:Disconnect()

            u340 = nil
        end
    end
end)