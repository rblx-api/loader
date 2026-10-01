local introSongIds, currentIntroSongIndex, Players, RunService, UserInputService, TweenService, Lighting, HttpService, Workspace
local localPlayer, currentCamera, getTime, clamp, floor, huge, sqrt, newVector3, zeroVector, newCFrame
local lookAtCFrame, getPlayersCached, waitForCharacterReady, carryController, colorThemes, outfits, currentOutfitIndex, outfitSelectorLabel, katanaSkinController, minecraftBatSkinController
local velocityHookedRoots, registerVelocityRoot, installVelocityReadHook, isHumanoidRagdolled, applyMovementVelocity, applyAnimationPack, disableAnimationPack, autoStealConnection, autoStealState, autoStealBusy
local getAutoStealVariantName, getAutoStealVariantIndex, teleportDown, antiRagdollController, antiRagdollV2State, enableAntiRagdollV2, disableAntiRagdollV2, antiDie, reapplyAntiDie, antiFlingShield
Programa local RagdollCountdown
local PRINTED_BRANDING = "FILTRADO POR discord.gg/printed"
función local addPrintedBranding(padre, posición, tamaño, tamaño de texto)
    si no es padre entonces
        devolver cero
    fin
    local existente = padre:FindFirstChild("PrintedBranding")
    si existe entonces
        devolver existente
    fin
    etiqueta local = Instancia.new("Etiqueta de texto")
    etiqueta.Nombre = "Marca impresa"
    etiqueta.Padre = padre
    label.Size = size o UDim2.new(1, -16, 0, 16)
    label.Position = posición o UDim2.new(0, 8, 1, -20)
    etiqueta.TransparenciaDeFondo = 1
    etiqueta.Texto = MARCA_IMPRESIÓN
    etiqueta.TextColor3 = Color3.fromRGB(210, 210, 220)
    etiqueta.TransparenciaTexto = 0.08
    etiqueta.Fuente = Enum.Fuente.GothamBold
    etiqueta.TextSize = textSize o 10
    etiqueta.TextXAlignment = Enum.TextXAlignment.Center
    etiqueta.AlineaciónTexto = Enumeración.AlineaciónTexto.Centro
    etiqueta.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    etiqueta.TextStrokeTransparency = 0,65
    etiqueta.ZIndex = 999
    etiqueta de devolución
fin

hacer
    Almacenamiento replicado local
    hacer
        local introTweenService, introRunService, introPlayer, introTrack, introSongFileName, introSound, introHeartbeatConnection
        si _G.BloodHoundsRunning entonces
            devolver
        fin
        _G.Perros de Sangre Corriendo = verdadero
        repetir
            tarea.espera()
        hasta que el juego:IsLoaded()
        hacer
            local introPlayersService = game:GetService("Players")
            introTweenService = game:GetService("TweenService")
            introducciónRunService = juego:GetService("RunService")
            introPlayer = introPlayersService.LocalPlayer
        fin
        introSongIds = {
            "https://files.catbox.moe/vbyghu.mp3",
            "https://files.catbox.moe/5g2wg1.mp3",
            "https://files.catbox.moe/r29x0i.mp3",
            "https://files.catbox.moe/n53amf.mp3",
            "https://files.catbox.moe/o4di3j.mp3",
            "https://files.catbox.moe/um4hgp.mp3",
            "https://files.catbox.moe/fiiu4a.mp3",
            "https://files.catbox.moe/mdjmee.mp3",
            "https://files.catbox.moe/2eysnf.mp3",
            "https://files.catbox.moe/d4uky5.mp3",
            "https://files.catbox.moe/8v5xra.mp3",
            "https://files.catbox.moe/aneanv.mp3",
            "https://files.catbox.moe/pm6lne.mp3",
            "https://files.catbox.moe/y4q5y3.mp3",
            "https://files.catbox.moe/pcdvty.mp3",
        }
        currentIntroSongIndex = 1
        pcall(función()
            Si es archivo y readfile y es archivo ("FictionHub.json") entonces
                local settingsData = game:GetService("HttpService"):JSONDecode(readfile("FictionHub.json"))
                Si type(settingsData.cleanHubSongIndex) == "número" entonces
                    local songCount = #introSongIds
                    currentIntroSongIndex = math.clamp(math.floor(settingsData.cleanHubSongIndex), 1, songCount)
                fin
            fin
        fin)
        introTrack = introSongIds[currentIntroSongIndex]
        introSongFileName = "cleanhub_intro_song_" .. currentIntroSongIndex .. ".mp3"
        introSound = nil
        introHeartbeatConnection = nil
        hacer
            local introGuiParents = {}
            local CoreGui = game:GetService("CoreGui")
            local playerGui = introPlayer and introPlayer:FindFirstChildOfClass("PlayerGui")
            introGuiParents[1] = CoreGui
            introGuiParents[2] = playerGui
            para _, guiParent en ipairs(introGuiParents) hacer
                guiParent = guiParent y guiParent:FindFirstChild("CleanLettersIntro")
                si guiParent entonces
                    guiParent:Destroy()
                fin
            fin
        fin
        hacer
            local introGui, introClosed, closeIntro
            introGui = Instance.new("ScreenGui")
            introGui.Name = "CleanLettersIntro"
            introGui.IgnoreGuiInset = verdadero
            introGui.ResetOnSpawn = false
            introGui.DisplayOrder = 100000
            introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            addPrintedBranding(introGui, UDim2.new(0, 0, 1, -42), UDim2.new(1, 0, 0, 22), 11)
            pcall(función()
                si syn y syn.protect_gui entonces
                    syn.protect_gui(introGui)
                fin
            fin)
            si no pcall(función()
                introGui.Parent = game:GetService("CoreGui")
            fin) entonces
                introGui.Parent = introPlayer:WaitForChild("PlayerGui")
            fin
            hacer
                local introLetters = {}
                local introAnimationStart = os.clock()
                introRenderConnection local = nulo
                introClosed = false
                para i, imageAssetId en ipairs({
                    "rbxassetid://102527460927859",
                    "rbxassetid://115218770459100",
                    "rbxassetid://79239854929751",
                    "rbxassetid://132491364078344",
                    "rbxassetid://88405482927089",
                }) hacer
                    local imageLabel = Instance.new("ImageLabel", introGui)
                    imageLabel.Name = "CleanLetter_" .. i
                    imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    imageLabel.Size = UDim2.fromOffset(72, 72)
                    imageLabel.Position = UDim2.new(0.5, (i - 3) * 40, 0.5, -18)
                    imageLabel.BackgroundTransparency = 1
                    imageLabel.Image = imageAssetId
                    imageLabel.ScaleType = Enum.ScaleType.Fit
                    imageLabel.ImageTransparency = 1
                    imageLabel.ZIndex = 3
                    introLetters[i] = {
                        imagen = etiqueta de imagen,
                        base = imageLabel.Position,
                        CleanHubIndex = i,
                    }
                    tarea.retraso((i - 1) * 0.07, función()
                        si imageLabel.Parent entonces
                            introTweenService
                                :Crear(
                                    etiqueta de imagen,
                                    TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                                    {
                                        ImageTransparency = 0,
                                    }
                                )
                                :Jugar()
                        fin
                    fin)
                fin
                closeIntro = función()
                    si se cierra entonces
                        devolver
                    fin
                    introClosed = true
                    si introRenderConnection entonces
                        introRenderConnection:Disconnect()
                    fin
                    si introHeartbeatConnection entonces
                        introHeartbeatConnection:Disconnect()
                        introHeartbeatConnection = nil
                    fin
                    si introSound entonces
                        pcall(función()
                            introSound:Stop()
                            introSound:Destroy()
                        fin)
                    fin
                    para _, letterEntry en ipairs(introLetters) hacer
                        Si letterEntry.image.Parent entonces
                            introTweenService
                                :Crear(letterEntry.image, TweenInfo.new(0.3), {
                                    ImageTransparency = 1,
                                })
                                :Jugar()
                        fin
                    fin
                    tarea.retraso(0.34, función()
                        si introGui entonces
                            introGui:Destroy()
                        fin
                    fin)
                fin
                introRenderConnection = introRunService.RenderStepped:Connect(function()
                    local tiempo transcurrido = os.clock() - inicio de animación de introducción
                    para _, letterEntry en ipairs(introLetters) hacer
                        imagen local = letterEntry.image
                        si imagen.Parent entonces
                            local animationPhase = tiempo transcurrido * 2.5 + letterEntry.CleanHubIndex * 1.37
                            imagen.Posición = entradaDeLetra.base
                                + UDim2.fromOffset(math.sin(animationPhase) * 18, math.cos(animationPhase * 1.5) * 22)
                            imagen.Rotación = math.sin(fase de animación * 0,72) * 7
                        fin
                    fin
                fin)
            fin
            tarea.spawn(función()
                función local resolveAssetPath(filePath)
                    para _, entrada en ipairs({
                        obtener recurso personalizado,
                        getsynasset,
                        obtener activo,
                    }) hacer
                        si typeof(entry) ~= "function" entonces
                            continuar
                        fin
                        local ok, resultado = pcall(función()
                            devolver entrada(rutaArchivo)
                        fin)
                        Si ok y type(result) == "string" y result ~= "" entonces
                            devolver resultado
                        fin
                    fin
                    devolver cero
                fin
                local soundAssetId = resolveAssetPath(introSongFileName)
                Si no existe soundAssetId y es archivo y es archivo(introSongFileName) entonces
                    soundAssetId = resolveAssetPath(introSongFileName)
                fin
                si no soundAssetId y writefile entonces
                    local ok, resultado = pcall(función()
                        juego de retorno:HttpGet(introTrack)
                    fin)
                    si
                        OK
                        y type(result) == "string"
                        y #resultado > 100
                        y pcall(función()
                            escribirarchivo(nombreArchivoCanciónIntroducción, resultado)
                        fin)
                    entonces
                        soundAssetId = resolveAssetPath(introSongFileName)
                    fin
                fin
                si introClosed o no soundAssetId entonces
                    devolver
                fin
                introSound = Instancia.new("Sonido")
                introSound.Name = "CleanIntroSong"
                introSound.SoundId = soundAssetId
                introSound.Volume = 1
                introSound.Looped = false
                introSound.Parent = game:GetService("SoundService")
                introHeartbeatConnection = introSound.Ended:Connect(closeIntro)
                pcall(función()
                    introSound:Play()
                fin)
            fin)
            hacer
                local skipIntroButton = Instance.new("TextButton", introGui)
                skipIntroButton.Size = UDim2.fromScale(1, 1)
                skipIntroButton.BackgroundTransparency = 1
                skipIntroButton.Text = ""
                skipIntroButton.BorderSizePixel = 0
                skipIntroButton.AutoButtonColor = false
                skipIntroButton.ZIndex = 10
                skipIntroButton.Activated:Connect(closeIntro)
            fin
            tarea.retraso(10, closeIntro)
            mientras no se introduceCerrado hacer
                tarea.espera(0.05)
            fin
        fin
    fin
    hacer
        Parámetros de raycast local
        tarea.espera(0.4)
        Jugadores = juego:GetService("Jugadores")
        RunService = juego:GetService("RunService")
        UserInputService = juego:GetService("UserInputService")
        TweenService = juego:ObtenerServicio("TweenService")
        Iluminación = juego:GetService("Iluminación")
        HttpService = juego:ObtenerServicio("HttpService")
        ReplicatedStorage = juego:GetService("ReplicatedStorage")
        Espacio de trabajo = juego:GetService("Espacio de trabajo")
        jugadorLocal = Jugadores.JugadorLocal
        cámaraactual = espacio de trabajo.CámaraActual
        obtenerTiempo = tick
        abrazadera = math.clamp
        piso = piso matemático
        enorme = matemáticas.enorme
        raíz cuadrada = math.sqrt
        nuevoVector3 = Vector3.new
        vectorcero = Vector3.cero
        nuevoCFrame = CFrame.new
        mirarCFrame = CFrame.mirar
        raycastParams = RaycastParams.new
        hacer
            jugadores locales = nulo
            local playerCacheTime = 0
            getPlayersCached = función()
                local ahora = obtenerTiempo()
                si los jugadores y ahora - playerCacheTime < 0.03 entonces
                    jugadores que regresan
                fin
                jugadores = Jugadores:ObtenerJugadores()
                playerCacheTime = ahora
                jugadores que regresan
            fin
        fin
        waitForCharacterReady = función(personaje, tiempo de espera)
            local waitDuration = tiempo de espera o 5
            fecha límite local = getTime() + waitDuration
            mientras
                no es un personaje
                o no personaje.Padre
                o no carácter:FindFirstChild("HumanoidRootPart")
                o no personaje:FindFirstChildOfClass("Humanoid")
            hacer
                si fecha límite < getTime() entonces
                    devolver falso
                fin
                tarea.espera(0.05)
            fin
            devolver verdadero
        fin
        NS = 60
        CS = 29
        VELOCIDAD_DE_RETRASO = 15
        LAGGER_CARRY_SPEED = 24.5
        MEDUSA_COOLDOWN = 25
        BAT_AIMBOT_SPEED = 58
        BYPASS_AIMBOT_SPEED = 60
        ANCHO_DEL_PANEL_MÓVIL = 128
        ALTURA_DEL_PANEL_MÓVIL = 294
        ARCHIVO_DE_CONFIGURACIÓN = "FictionHub.json"
        BAT_V2_HIT_DIST = 4.5
        _isDraggingButton = false
        índice de fondo = 1
        backgroundImageTransparency = 0,55
        floatingButtonScale = 1
        escala de la barra de progreso = 1
        _floatingUIScales = {}
        carryController = {
            velocidad normal = NS,
            Velocidad de acarreo = CS,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            speedToggled = false,
            laggerMode = 0,
            softStealEnabled = falso,
            softStealRadius = 10,
            softStealSpeed = 30,
            softStealLatched = falso,
            _isCarrying = falso,
            _lastCarryCheck = 0,
            _lvBoost = nil,
            _lvAtt = nulo,
            _blockedTime = 0,
            _maxForce = 2200,
            _freeForce = 500,
            _heartbeatConn = nil,
            _softStealScanner = nil,
            _softStealAnimals = {},
            _softStealScanning = falso,
            _estado = nulo,
            _dropInProgress = false,
            _batAimbotToggled = false,
            _rayParams = nil,
            _rayFilter = nil,
            _rayFilterTime = 0,
            isCarrying = función(self)
                local ahora = obtenerTiempo()
                Si ahora - (self._lastCarryCheck o 0) < 0.1 entonces
                    devolver self._isCarrying
                fin
                self._lastCarryCheck = ahora
                Personaje local = jugador local.Personaje
                si no es un personaje entonces
                    self._isCarrying = false
                    devolver falso
                fin
                local humanoide = personaje:FindFirstChildOfClass("Humanoid")
                Velocidad de caminar local = humanoide y humanoide.WalkSpeed o 16
                local isCarrying = walkSpeed < 25 y walkSpeed > 0
                local ok, resultado = pcall(función()
                    return localPlayer:GetAttribute("Robando")
                fin)
                ok = ok y resultado == verdadero
                local isEnabled = false
                Si está bien entonces
                    isEnabled = true
                fin
                local ok2, resultado2 = pcall(función()
                    return character:GetAttribute("Robando")
                fin)
                si ok2 y result2 == verdadero entonces
                    isEnabled = true
                fin
                si no está habilitado entonces
                    para _, nombre en ipairs({
                        "Que lleva",
                        "Está llevando",
                        "Agarrado",
                        "Tenencia",
                        "Robar y mantener",
                        "HasGrab",
                    }) hacer
                        instancia local = carácter:FindFirstChild(nombre)
                        si instancia entonces
                            si
                                instancia:IsA("BoolValue") e instancia.Value
                                o instancia:IsA("ObjectValue") e instancia.Value
                                o instancia:IsA("StringValue") e instancia.Value ~= ""
                            entonces
                                isEnabled = true
                                romper
                            fin
                        fin
                    fin
                fin
                self._isCarrying = isCarrying o isEnabled
                devolver self._isCarrying
            fin,
            obtenerVelocidadActiva = función(self)
                si self._state y (self._state.autoLeftEnabled o self._state.autoRightEnabled) entonces
                    devolver self.normalSpeed
                fin
                si self.softStealEnabled entonces
                    local _, distancia = self:getNearestSoftStealAnimal(self.softStealRadius)
                    Si distancia y distancia <= self.softStealRadius entonces
                        self.softStealLatched = true
                        devolver self.softStealSpeed
                    fin
                    Si self.softStealLatched y self:isCarrying() entonces
                        devolver self.softStealSpeed
                    fin
                    self.softStealLatched = false
                fin
                si self.laggerMode == 1 entonces
                    devolver self.laggerSpeed
                fin
                si self.laggerMode == 2 entonces
                    devolver self.laggerCarrySpeed
                fin
                si self.speedToggled entonces
                    devolver self.carrySpeed
                fin
                devolver self.normalSpeed
            fin,
            obtenerEstado = función(self)
                si no (self._state y (se