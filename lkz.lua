-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1790276456885
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- Jumpscare Scripti (LKZ Hub Yüklenmeden Önce Çalışır)

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- 1. Korkutucu Ses Oluşturma ve Çalma
local scareSound = Instance.new("Sound")
scareSound.SoundId = "rbxassetid://9114223176" -- Yüksek sesli çığlık / jumpscare sesi ID'si
scareSound.Volume = 10 -- Yüksek ses seviyesi
scareSound.Parent = SoundService
scareSound:Play()

-- 2. Ekranı Kaplayan Korkunç Resim (UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JumpscareGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Tam ekran yap

-- Roblox GuiParent güvenliği
local parentTarget = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui.Parent = parentTarget

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.Image = "rbxassetid://6551061803" -- Korkutucu yüz resmi ID'si
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = screenGui

-- 3. Ekran Sallantı ve Flaş Efekti (Efekt Güçlendirme)
task.spawn(function()
    for i = 1, 15 do
        imageLabel.Position = UDim2.new(0, math.random(-20, 20), 0, math.random(-20, 20))
        task.wait(0.03)
    end
    imageLabel.Position = UDim2.new(0, 0, 0, 0)
end)

-- 4. 2 Saniye Sonra Jumpscare'i Kaldır ve Asıl Scripti (LKZ Hub) Çalıştır
task.delay(2, function()
    -- Jumpscare temizleme
    scareSound:Destroy()
    screenGui:Destroy()
    
    -- LKZ Hub Yükleyici
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LucasggkX/LKZ-Hub/refs/heads/main/Loader.lua"))()
end)